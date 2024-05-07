package com.moass.api.domain.reservation.service;

import com.moass.api.domain.reservation.dto.ReservationCreateDto;
import com.moass.api.domain.reservation.dto.ReservationInfoCreateDto;
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
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.time.LocalDate;
import java.time.ZoneId;

@Slf4j
@Service
@RequiredArgsConstructor
public class ReservationService {

    private final ClassRepository classRepository;
    private final ReservationRepository reservationRepository;
    private final ReservationInfoRepository reservationInfoRepository;
    private final UserReservationInfoRepository userReservationInfoRepository;
    public Mono<Reservation> createReservation(UserInfo userInfo, ReservationCreateDto reservationCreateDto){
        return reservationRepository.save(new Reservation(reservationCreateDto))
                .flatMap(savedReservation -> {
                    if (reservationCreateDto.getInfoTimes() == null || reservationCreateDto.getInfoTimes().isEmpty()) {
                        return Mono.just(savedReservation);
                    } else {
                        return BannedReservationInfo(userInfo, savedReservation, reservationCreateDto)
                                .thenReturn(savedReservation);
                    }
                });
    }

    public Mono<Reservation> patchReservation(ReservationPatchDto reservationPatchDto) {
        return reservationRepository.findById(reservationPatchDto.getReservationId())
                .flatMap(existingReservation -> {
                    copyNonNullProperties(reservationPatchDto, existingReservation);
                    return reservationRepository.save(existingReservation);
                })
                .switchIfEmpty(Mono.error(new CustomException("해당 예약항목이 존재하지 않습니다.", HttpStatus.NOT_FOUND)));
    }

    private Mono<ReservationInfo> BannedReservationInfo(UserInfo userInfo, Reservation reservation, ReservationCreateDto reservationCreateDto) {
        return Flux.fromIterable(reservationCreateDto.getInfoTimes())
                .flatMap(infoTime -> reservationInfoRepository.save(ReservationInfo.builder()
                        .reservationId(reservation.getReservationId())
                        .userId(userInfo.getUserId())
                        .infoState(2)
                        .infoName("XXXX")
                        .infoDate(LocalDate.of(9999, 12, 31))
                        .infoTime(infoTime)
                        .build()))
                .collectList()
                .flatMapMany(reservationInfos -> Flux.fromIterable(reservationInfos)
                        .flatMap(reservationInfo -> userReservationInfoRepository.save(new UserReservationInfo(reservationInfo.getInfoId(), userInfo.getUserId())))
                        .thenMany(Flux.fromIterable(reservationInfos)))
                .last();
    }



    private void copyNonNullProperties(ReservationPatchDto source, Reservation target) {
        if (source.getCategory() != null) target.setCategory(source.getCategory());
        if (source.getTimeLimit() != null) target.setTimeLimit(source.getTimeLimit());
        if (source.getReservationName() != null) target.setReservationName(source.getReservationName());
        if (source.getColorCode() != null) target.setColorCode(source.getColorCode());
    }

    public Mono<Reservation> deleteReservation(Integer reservationId) {
        return reservationRepository.findByReservationId(reservationId)
                .flatMap(reservation -> reservationRepository.delete(reservation).thenReturn(reservation))
                .switchIfEmpty(Mono.error(new CustomException("해당 예약항목이 존재하지 않습니다.", HttpStatus.NOT_FOUND)));
    }
}
