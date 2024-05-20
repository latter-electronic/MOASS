package com.moass.api.domain.reservation.controller;

import com.moass.api.domain.reservation.dto.ReservationCreateDto;
import com.moass.api.domain.reservation.dto.ReservationPatchDto;
import com.moass.api.domain.reservation.service.ReservationService;
import com.moass.api.global.annotaion.Login;
import com.moass.api.global.auth.dto.UserInfo;
import com.moass.api.global.exception.CustomException;
import com.moass.api.global.response.ApiResponse;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Mono;

@Slf4j
@RestController
@RequestMapping("/reservation")
@RequiredArgsConstructor
public class ReservationController {


    final ReservationService reservationService;



    @PreAuthorize("hasRole('ADMIN') or hasRole('CONSULTANT')")
    @PostMapping()
    public Mono<ResponseEntity<ApiResponse>> createReservation(@Login UserInfo userInfo, @Valid @RequestBody ReservationCreateDto reservationCreateDto){
        return reservationService.createReservation(userInfo, reservationCreateDto)
                .flatMap(reservationId -> ApiResponse.ok("예약 생성 성공", reservationId))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("예약 실패 : " + e.getMessage(), e.getStatus()));
    }

    @PreAuthorize("hasRole('ADMIN') or hasRole('CONSULTANT')")
    @PatchMapping()
    public Mono<ResponseEntity<ApiResponse>> patchReservation(@Login UserInfo userInfo, @RequestBody ReservationPatchDto reservationPatchDto){
        return reservationService.patchReservation(userInfo, reservationPatchDto)
                .flatMap(reservationId -> ApiResponse.ok("예약 수정 성공", reservationId))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("예약 실패 : " + e.getMessage(), e.getStatus()));
    }

    @PreAuthorize("hasRole('ADMIN') or hasRole('CONSULTANT')")
    @DeleteMapping("/{reservationId}")
    public Mono<ResponseEntity<ApiResponse>> deleteReservation(@PathVariable Integer reservationId){
        return reservationService.deleteReservation(reservationId)
                .flatMap(reservation -> ApiResponse.ok("예약 삭제 성공", reservation))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("예약 삭제 실패 : " + e.getMessage(), e.getStatus()));
    }
}
