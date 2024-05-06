package com.moass.api.domain.reservation.service;

import com.moass.api.domain.reservation.dto.MyReservationInfoDetailDto;
import com.moass.api.domain.reservation.dto.ReservationDetailDto;
import com.moass.api.domain.reservation.dto.ReservationInfoCreateDto;
import com.moass.api.domain.reservation.entity.Reservation;
import com.moass.api.domain.reservation.entity.ReservationInfo;
import com.moass.api.domain.reservation.entity.UserCount;
import com.moass.api.domain.reservation.entity.UserReservationInfo;
import com.moass.api.domain.reservation.repository.ReservationInfoRepository;
import com.moass.api.domain.reservation.repository.ReservationRepository;
import com.moass.api.domain.reservation.repository.UserReservationInfoRepository;
import com.moass.api.domain.user.dto.UserSearchInfoDto;
import com.moass.api.domain.user.repository.SsafyUserRepository;
import com.moass.api.domain.user.repository.UserRepository;
import com.moass.api.global.auth.dto.UserInfo;
import com.moass.api.global.exception.CustomException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.time.LocalDate;
import java.time.ZoneId;
import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class ReservationInfoService {

    private final ReservationInfoRepository reservationInfoRepository;
    private final UserReservationInfoRepository userReservationInfoRepository;
    private final ReservationRepository reservationRepository;
    private final UserRepository userRepository;
    private final SsafyUserRepository ssafyUserRepository;

    @Transactional
    public Mono<ReservationInfo> createReservationInfo(UserInfo userInfo, ReservationInfoCreateDto reservationInfoCreateDto) {
        return reservationRepository.findById(reservationInfoCreateDto.getReservationId())
                .switchIfEmpty(Mono.error(new CustomException("예약 항목을 찾을 수 없습니다.", HttpStatus.NOT_FOUND)))
                .flatMap(reservation -> {
                    return checkUserReservationTime(reservationInfoCreateDto, reservation.getTimeLimit())
                            .flatMap(overLimitUsers -> {
                                if (!overLimitUsers.isEmpty()) {
                                    return Mono.error(new CustomException("일부 사용자의 예약 시간이 제한을 초과합니다: " + overLimitUsers, HttpStatus.CONFLICT));
                                }
                                return checkAndSaveReservation(userInfo, reservationInfoCreateDto);
                            });
                });
    }

    // 유저들이 해당 날짜와 해당 예약항목에서 더 예약할 수 있는지 확인
    private Mono<List<String>> checkUserReservationTime(ReservationInfoCreateDto resInfoCreateDto, Integer timeLimit) {
        return userReservationInfoRepository.countByReservationIdAndDate(resInfoCreateDto.getReservationId(), resInfoCreateDto.getInfoDate())
                .collectList()
                .map(userCounts -> {
                    Map<String, Integer> MapUserCounts = new HashMap<>();
                    for (UserCount count : userCounts) {
                        MapUserCounts.put(count.getUserId(), count.getCount().intValue());
                    }
                    int infoTimesLength = resInfoCreateDto.getInfoTimes().size();
                    List<String> overLimitUsers = new ArrayList<>();
                    for (String userId : resInfoCreateDto.getInfoUsers()) {
                        if (MapUserCounts.containsKey(userId) && infoTimesLength + MapUserCounts.get(userId) > timeLimit) {
                            overLimitUsers.add(userId);
                        } else if (infoTimesLength > timeLimit && !overLimitUsers.contains(userId)) {
                            overLimitUsers.add(userId);
                        }
                    }
                    return overLimitUsers;
                });
    }

    private Mono<ReservationInfo> checkAndSaveReservation(UserInfo userInfo, ReservationInfoCreateDto reservationInfoCreateDto) {
        return reservationInfoRepository.findInfoTimeByReservationIdAndInfoDate(
                        reservationInfoCreateDto.getReservationId(), reservationInfoCreateDto.getInfoDate())
                .collectList()
                .flatMap(alreadyInfoTimes -> {
                    for (Integer infoTime : reservationInfoCreateDto.getInfoTimes()) {
                        if (alreadyInfoTimes.contains(infoTime)) {
                            return Mono.error(new CustomException("이미 예약된 시간입니다: " + convertNumberToTimeSlot(infoTime), HttpStatus.CONFLICT));
                        }
                    }

                    // 예약 정보 저장
                    return Flux.fromIterable(reservationInfoCreateDto.getInfoTimes())
                            .flatMap(infoTime -> reservationInfoRepository.save(ReservationInfo.builder()
                                    .reservationId(reservationInfoCreateDto.getReservationId())
                                    .userId(userInfo.getUserId())
                                    .infoState(1)
                                    .infoName(reservationInfoCreateDto.getInfoName())
                                    .infoDate(reservationInfoCreateDto.getInfoDate())
                                    .infoTime(infoTime)
                                    .build()))
                            .collectList()
                            .flatMap(reservationInfos -> Flux.fromIterable(reservationInfos)
                                    .flatMap(reservationInfo ->
                                            Flux.fromIterable(reservationInfoCreateDto.getInfoUsers())
                                                    .flatMap(userId -> userReservationInfoRepository.save(new UserReservationInfo(reservationInfo.getInfoId(), userId)))
                                    ).then(Mono.just(reservationInfos.get(0))));
                });
    }

    public String convertNumberToTimeSlot(int number) {
        if (number < 1 || number > 18) {
            throw new IllegalArgumentException("숫자는 1부터 18사이의 값이어야 합니다.");
        }

        int baseHour = 9;
        int baseMinute = 0;
        int totalMinutes = (number - 1) * 30;
        int hoursToAdd = totalMinutes / 60;
        int minutesToAdd = totalMinutes % 60;

        int startHour = baseHour + hoursToAdd;
        int startMinute = baseMinute + minutesToAdd;

        int endHour = startHour;
        int endMinute = startMinute + 30;
        if (endMinute == 60) {
            endHour += 1;
            endMinute = 0;
        }

        return String.format("%d:%02d~%d:%02d", startHour, startMinute, endHour, endMinute);
    }

    public Mono<List<ReservationDetailDto>> getTodayReservationInfo(UserInfo userInfo) {
        log.info(String.valueOf(LocalDate.now(ZoneId.of("Asia/Seoul"))));
        return ssafyUserRepository.findClassCodeByUserId(userInfo.getUserId())
                .switchIfEmpty(Mono.error(new CustomException("해당 사용자의 클래스 코드를 찾을 수 없습니다.", HttpStatus.NOT_FOUND)))
                .flatMapMany(classCode -> reservationRepository.findByClassCode(classCode))
                .flatMap(reservation -> reservationInfoRepository.findByReservationIdAndInfoDate(reservation.getReservationId(), LocalDate.now(ZoneId.of("Asia/Seoul")))
                        .collectList()
                        .map(infos -> createReservationDetailDto(reservation, infos)))
                .collectList();
    }

    private ReservationDetailDto createReservationDetailDto(Reservation reservation, List<ReservationInfo> infos) {
        ReservationDetailDto dto = new ReservationDetailDto();
        dto.setReservationId(reservation.getReservationId());
        dto.setClassCode(reservation.getClassCode());
        dto.setCategory(reservation.getCategory());
        dto.setTimeLimit(reservation.getTimeLimit());
        dto.setReservationName(reservation.getReservationName());
        dto.setColorCode(reservation.getColorCode());
        dto.setReservationInfoList(infos);
        return dto;
    }

    public Mono<List<ReservationDetailDto>> searchReservationInfo(UserInfo userInfo, LocalDate searchDate) {
        return ssafyUserRepository.findClassCodeByUserId(userInfo.getUserId())
                .switchIfEmpty(Mono.error(new CustomException("해당 사용자의 클래스 코드를 찾을 수 없습니다.", HttpStatus.NOT_FOUND)))
                .flatMapMany(classCode -> reservationRepository.findByClassCode(classCode))
                .flatMap(reservation -> reservationInfoRepository.findByReservationIdAndInfoDate(reservation.getReservationId(), searchDate)
                        .collectList()
                        .map(infos -> createReservationDetailDto(reservation, infos)))
                .collectList();
    }

    public Mono<String> deleteReservationInfo(UserInfo userInfo, Integer reservationInfoId) {
        return reservationInfoRepository.findByUserIdAndReservationInfoId(userInfo.getUserId(), reservationInfoId)
                .switchIfEmpty(Mono.error(new CustomException("예약 정보가 일치하지 않습니다. : " + reservationInfoId, HttpStatus.NOT_FOUND)))
                .flatMap(reservationInfo ->
                        userReservationInfoRepository.deleteByInfoId(reservationInfo.getInfoId())
                                .then(reservationInfoRepository.delete(reservationInfo))
                                .thenReturn(reservationInfo.getInfoId().toString())
                                .onErrorResume(e -> Mono.error(new CustomException("삭제중 에러가 발생하였습니다. ", HttpStatus.INTERNAL_SERVER_ERROR)))
                );
    }

    public Mono<Map<String,List<ReservationDetailDto>>> getWeekReservationInfo(UserInfo userInfo) {
        Map<String, List<ReservationDetailDto>> weekReservationInfo = new HashMap<>();
        LocalDate today = LocalDate.now(ZoneId.of("Asia/Seoul"));

        return Flux.range(0, 7)
                .flatMap(day -> {
                    LocalDate searchDate = today.plusDays(day);
                    return searchReservationInfo(userInfo, searchDate)
                            .doOnNext(reservationDetailDtos -> weekReservationInfo.put(searchDate.toString(), reservationDetailDtos));
                })
                .then(Mono.just(weekReservationInfo));
    }

    public Mono<List<MyReservationInfoDetailDto>> getReservationInfo(String userId) {
        return reservationInfoRepository.findByUserReservationUserId(userId)
                .flatMap(reservationInfo ->
                        userReservationInfoRepository.findUserSearchDetailByInfoId(reservationInfo.getInfoId())
                                .map(userSearchDetail -> new UserSearchInfoDto(userSearchDetail))
                                .collectList()
                                .map(userSearchInfoDtos -> new MyReservationInfoDetailDto(
                                        reservationInfo,
                                        userSearchInfoDtos
                                ))
                )
                .collectList()
                    .map(list -> list.stream()
                .sorted(Comparator.comparing(MyReservationInfoDetailDto::getInfoDate)
                        .thenComparing(MyReservationInfoDetailDto::getInfoTime))
                .collect(Collectors.toList()));
    }


}