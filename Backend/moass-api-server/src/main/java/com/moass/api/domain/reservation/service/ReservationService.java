package com.moass.api.domain.reservation.service;

import com.moass.api.domain.reservation.dto.ReservationCreateDto;
import com.moass.api.domain.reservation.dto.ReservationPatchDto;
import com.moass.api.domain.reservation.entity.Reservation;
import com.moass.api.domain.reservation.repository.ReservationRepository;
import com.moass.api.domain.user.repository.ClassRepository;
import com.moass.api.global.exception.CustomException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;

@Slf4j
@Service
@RequiredArgsConstructor
public class ReservationService {

    private final ClassRepository classRepository;
    private final ReservationRepository reservationRepository;

    public Mono<Reservation> createReservation(ReservationCreateDto reservationCreateDto){
        return classRepository.existsByClassCode(reservationCreateDto.getClassCode())
                .flatMap(exists -> {
                    if (exists) {
                        return reservationRepository.save(new Reservation(reservationCreateDto));
                    } else {
                        return Mono.error(new CustomException("해당 클래스 코드가 존재하지 않습니다.", HttpStatus.BAD_REQUEST));
                    }
                })
                .switchIfEmpty(Mono.error(new CustomException("저장중 오류가 발생하였습니다.", HttpStatus.CONFLICT)));
    }

    public Mono<Reservation> patchReservation(ReservationPatchDto reservationPatchDto) {
        return reservationRepository.findById(reservationPatchDto.getReservationId())
                .flatMap(existingReservation -> {
                    copyNonNullProperties(reservationPatchDto, existingReservation);
                    return reservationRepository.save(existingReservation);
                })
                .switchIfEmpty(Mono.error(new CustomException("해당 예약항목이 존재하지 않습니다.", HttpStatus.NOT_FOUND)));
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
