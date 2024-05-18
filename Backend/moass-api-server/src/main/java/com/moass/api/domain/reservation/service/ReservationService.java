package com.moass.api.domain.reservation.service;

import com.moass.api.domain.reservation.dto.ReservationCreateDto;
import com.moass.api.domain.reservation.dto.ReservationPatchDto;
import com.moass.api.domain.reservation.entity.Reservation;
import com.moass.api.domain.reservation.entity.ReservationInfo;
import com.moass.api.domain.reservation.entity.UserReservationInfo;
import com.moass.api.domain.reservation.repository.ReservationInfoRepository;
import com.moass.api.domain.reservation.repository.ReservationRepository;
import com.moass.api.domain.reservation.repository.UserReservationInfoRepository;
import com.moass.api.domain.user.repository.ClassRepository;
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

@Slf4j
@Service
@RequiredArgsConstructor
public class ReservationService {

    private final LocalDate globalBanDate = LocalDate.parse("9999-12-31");
    private final ClassRepository classRepository;
    private final ReservationRepository reservationRepository;
    private final ReservationInfoRepository reservationInfoRepository;
    private final UserReservationInfoRepository userReservationInfoRepository;
    private final ReservationInfoService reservationInfoService;
    public Mono<Reservation> createReservation(UserInfo userInfo, ReservationCreateDto reservationCreateDto){
        return classRepository.findByClassCode(reservationCreateDto.getClassCode())
                        .switchIfEmpty(Mono.error(new CustomException("해당 클래스가 존재하지 않습니다.", HttpStatus.NOT_FOUND)))
                        .flatMap(existsClass ->  reservationRepository.save(new Reservation(reservationCreateDto)))
                        .flatMap(savedReservation -> {
                    if (reservationCreateDto.getInfoTimes() == null || reservationCreateDto.getInfoTimes().isEmpty()) {
                        return Mono.just(savedReservation);
                    } else {
                        return banMultipleTimes(userInfo, savedReservation, reservationCreateDto,LocalDate.of(9999, 12, 31))
                                .thenReturn(savedReservation);
                    }
                });
    }

    @Transactional
    public Mono<Boolean> patchReservation(UserInfo userInfo, ReservationPatchDto reservationPatchDto) {
        return reservationRepository.findById(reservationPatchDto.getReservationId())
                .switchIfEmpty(Mono.error(new CustomException("해당 예약항목이 존재하지 않습니다.", HttpStatus.NOT_FOUND)))
                .flatMap(existingReservation -> {
                    copyNonNullProperties(reservationPatchDto, existingReservation);
                    return reservationRepository.save(existingReservation);
                })
                .flatMap(savedReservation -> {
                    if (reservationPatchDto.getInfoDate() == null || reservationPatchDto.getInfoTimes().isEmpty() || reservationPatchDto.getInfoTimes() == null) {
                        return Mono.just(true);
                    } else {
                        return toggleBanAndUpdateReservationInfo(userInfo, savedReservation, reservationPatchDto);
                    }
                });
    }

    private Mono<Boolean> toggleBanAndUpdateReservationInfo(UserInfo userInfo, Reservation reservation, ReservationPatchDto reservationPatchDto) {
        return Flux.fromIterable(reservationPatchDto.getInfoTimes())
                .flatMap(infoTime -> reservationInfoRepository.findByReservationIdAndInfoTime(reservation.getReservationId(), infoTime)
                        .flatMap(reservationInfo -> {
                            if (reservationInfo.getInfoState() == 1) {
                                return reservationInfoService.deleteReservationInfoByAdmin(reservationInfo.getInfoId())
                                        .then(banSingleReservation(reservation.getReservationId(), userInfo, infoTime, reservationPatchDto.getInfoDate()))
                                        .thenReturn(true);
                            } else if (reservationInfo.getInfoState() == 2) {
                                return reservationInfoService.deleteReservationInfoByAdmin(reservationInfo.getInfoId())
                                        .thenReturn(false);
                            }
                            return Mono.just(false);
                        })
                        .switchIfEmpty(banSingleReservation(reservation.getReservationId(), userInfo, infoTime, reservationPatchDto.getInfoDate())
                                .thenReturn(true))
                )
                .collectList()
                .map(results -> results.contains(true));
    }

    private Mono<ReservationInfo> banMultipleTimes(UserInfo userInfo,Reservation reservation,  ReservationCreateDto reservationCreateDto, LocalDate banDate) {
        return Flux.fromIterable(reservationCreateDto.getInfoTimes())
                .flatMap(infoTime -> banSingleReservation(reservation.getReservationId(), userInfo, infoTime, banDate))
                .then(Mono.just(new ReservationInfo()));
    }

    private Mono<Void> banSingleReservation(Integer reservationId, UserInfo userInfo, Integer infoTime,LocalDate banDate) {
        if(banDate.equals(globalBanDate)){
            return createGlobalBannedReservationInfo(reservationId, userInfo, infoTime, banDate)
                    .flatMap(reservationInfo -> userReservationInfoRepository.save(new UserReservationInfo(reservationInfo.getInfoId(), userInfo.getUserId())))
                    .then();
        }else {
            return createBannedReservationInfo(reservationId, userInfo, infoTime, banDate)
                    .flatMap(reservationInfo -> userReservationInfoRepository.save(new UserReservationInfo(reservationInfo.getInfoId(), userInfo.getUserId())))
                    .then();
        }
    }

    private Mono<ReservationInfo> createGlobalBannedReservationInfo(Integer reservationId, UserInfo userInfo, Integer infoTime, LocalDate banDate) {
        return reservationInfoRepository.save(ReservationInfo.builder()
                .reservationId(reservationId)
                .userId(userInfo.getUserId())
                .infoState(3)
                .infoName("XXXX")
                .infoDate(banDate)
                .infoTime(infoTime)
                .build());
    }

    private Mono<ReservationInfo> createBannedReservationInfo(Integer reservationId, UserInfo userInfo, Integer infoTime, LocalDate banDate) {
        return reservationInfoRepository.save(ReservationInfo.builder()
                .reservationId(reservationId)
                .userId(userInfo.getUserId())
                .infoState(2)
                .infoName("XXXX")
                .infoDate(banDate)
                .infoTime(infoTime)
                .build());
    }

    private void copyNonNullProperties(ReservationPatchDto source, Reservation target) {
        if (source.getCategory() != null) target.setCategory(source.getCategory());
        if (source.getTimeLimit() != null) target.setTimeLimit(source.getTimeLimit());
        if (source.getReservationName() != null) target.setReservationName(source.getReservationName());
        if (source.getColorCode() != null) target.setColorCode(source.getColorCode());
    }

    @Transactional
    public Mono<Reservation> deleteReservation(Integer reservationId) {
        return reservationRepository.findByReservationId(reservationId)
                .switchIfEmpty(Mono.error(new CustomException("해당 예약 항목이 존재하지 않습니다.", HttpStatus.NOT_FOUND)))
                .flatMap(reservation ->
                        userReservationInfoRepository.deleteByReservationId(reservation.getReservationId())
                                .then(reservationInfoRepository.deleteByReservationId(reservationId))
                                .then(reservationRepository.deleteById(reservationId))
                                .thenReturn(reservation)
                );
    }
}
