package com.moass.api.domain.reservation.service;

import com.moass.api.domain.reservation.dto.ReservationInfoCreateDto;
import com.moass.api.domain.reservation.entity.ReservationInfo;
import com.moass.api.domain.reservation.entity.UserCount;
import com.moass.api.domain.reservation.entity.UserReservationInfo;
import com.moass.api.domain.reservation.repository.ReservationInfoRepository;
import com.moass.api.domain.reservation.repository.ReservationRepository;
import com.moass.api.domain.reservation.repository.UserReservationInfoRepository;
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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class ReservationInfoService {

    private final ReservationInfoRepository reservationInfoRepository;
    private final UserReservationInfoRepository userReservationInfoRepository;
    private final ReservationRepository reservationRepository;
    private final UserRepository userRepository;


    @Transactional
    public Mono<ReservationInfo> createReservationInfo(UserInfo userInfo, ReservationInfoCreateDto reservationInfoCreateDto) {
        return reservationRepository.findById(reservationInfoCreateDto.getReservationId())
                .switchIfEmpty(Mono.error(new CustomException("예약 항목을 찾을 수 없습니다.", HttpStatus.NOT_FOUND)))
                .flatMap(reservation -> {
                    int timeLimit = reservation.getTimeLimit();
                    return checkUserReservationTime(reservationInfoCreateDto.getInfoUsers(), reservationInfoCreateDto.getReservationId(), reservationInfoCreateDto.getInfoDate(), reservationInfoCreateDto.getInfoTimes(), timeLimit)
                            .flatMap(overLimitUsers -> {
                                if (!overLimitUsers.isEmpty()) {
                                    return Mono.error(new CustomException("일부 사용자의 예약 시간이 제한을 초과합니다: " + overLimitUsers, HttpStatus.CONFLICT));
                                }
                                return checkAndSaveReservation(userInfo, reservationInfoCreateDto);
                            });
                });
    }

    private Mono<List<String>> checkUserReservationTime(List<String> userIds, Integer reservationId, LocalDate infoDate, List<Integer> infoTimes,Integer timeLimit) {
        return userReservationInfoRepository.countByReservationIdAndDate(reservationId, infoDate)
                .collectList()
                .map(userCounts -> {
                    Map<String,Integer> MapUserCounts = new HashMap<>();
                    for(UserCount count : userCounts){
                        MapUserCounts.put(count.getUserId(),count.getCount().intValue());
                    }
                    List<String> overLimitUsers = new ArrayList<>();
                    for (String userId : userIds) {
                        log.info(Integer.toString(infoTimes.size()));
                        log.info(userIds.toString());
                        log.info(MapUserCounts.toString());
                        //log.info(Integer.toString(MapUserCounts.get(userId)));
                        if(MapUserCounts.containsKey(userId)&&infoTimes.size()+MapUserCounts.get(userId)>timeLimit){
                            overLimitUsers.add(userId);
                        }else if(infoTimes.size()>timeLimit&&!overLimitUsers.contains(userId)){
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
                            .flatMap(reservationInfos -> {
                                // UserReservationInfo에 유저 저장
                                return Flux.fromIterable(reservationInfos)
                                        .flatMap(reservationInfo ->
                                                Flux.fromIterable(reservationInfoCreateDto.getInfoUsers())
                                                        .flatMap(userId -> userReservationInfoRepository.save(new UserReservationInfo(reservationInfo.getInfoId(), userId)))
                                        ).then(Mono.just(reservationInfos.get(0))); // 예약 정보 중 첫 번째 반환
                            });
                });
    }

    public String convertNumberToTimeSlot(int number) {
        if (number < 1 || number > 18) {
            throw new IllegalArgumentException("Number must be between 1 and 18");
        }

        // 기본 시작 시간: 9:00 (9시 0분)
        int baseHour = 9;
        int baseMinute = 0;

        // 각 번호에 30분을 더함
        int totalMinutes = (number - 1) * 30;
        int hoursToAdd = totalMinutes / 60;
        int minutesToAdd = totalMinutes % 60;

        // 시작 시간 계산
        int startHour = baseHour + hoursToAdd;
        int startMinute = baseMinute + minutesToAdd;

        // 종료 시간 계산
        int endHour = startHour;
        int endMinute = startMinute + 30;
        if (endMinute == 60) {
            endHour += 1;
            endMinute = 0;
        }

        // 시간 문자열 형식: HH:mm~HH:mm
        return String.format("%d:%02d~%d:%02d", startHour, startMinute, endHour, endMinute);
    }
}