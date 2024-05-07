package com.moass.api.domain.reservation.controller;

import com.moass.api.domain.reservation.dto.ReservationInfoCreateDto;
import com.moass.api.domain.reservation.service.ReservationInfoService;
import com.moass.api.global.annotaion.Login;
import com.moass.api.global.auth.dto.UserInfo;
import com.moass.api.global.exception.CustomException;
import com.moass.api.global.response.ApiResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Hooks;
import reactor.core.publisher.Mono;

import java.time.LocalDate;

@Slf4j
@RestController
@RequestMapping("/reservationinfo")
@RequiredArgsConstructor
public class ReservationInfoController {

    final ReservationInfoService reservationInfoService;
    @PostMapping
    public Mono<ResponseEntity<ApiResponse>> createReservationInfo(@Login UserInfo userInfo, @RequestBody ReservationInfoCreateDto reservationInfoCreateDto){
        return reservationInfoService.createReservationInfo(userInfo,reservationInfoCreateDto)
                .flatMap(reservationInfoId -> ApiResponse.ok("예약 정보 생성 성공", reservationInfoId))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("예약 정보 생성 실패 : " + e.getMessage(), e.getStatus()));
    }


    @GetMapping("/today")
    public Mono<ResponseEntity<ApiResponse>> gettodayReservationInfo(@Login UserInfo userInfo){
        return reservationInfoService.getTodayReservationInfo(userInfo)
                .flatMap(reservationDetailDtos -> ApiResponse.ok("오늘 예약 정보 조회 성공", reservationDetailDtos))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("오늘 예약 정보 조회 실패 : " + e.getMessage(), e.getStatus()));
    }

    @GetMapping("/search")
    public Mono<ResponseEntity<ApiResponse>> gettodayReservationInfo(@Login UserInfo userInfo, @RequestParam LocalDate date){
        return reservationInfoService.searchReservationInfo(userInfo,date)
                .flatMap(reservationDetailDtos -> ApiResponse.ok("예약 정보 조회 성공", reservationDetailDtos))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("오늘 예약 정보 조회 실패 : " + e.getMessage(), e.getStatus()));
    }

    @GetMapping("/week")
    public Mono<ResponseEntity<ApiResponse>> getWeekReservationInfo(@Login UserInfo userInfo){
        return reservationInfoService.getWeekReservationInfo(userInfo)
                .flatMap(reservationDetailDtos -> ApiResponse.ok("오늘 예약 정보 조회 성공", reservationDetailDtos))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("오늘 예약 정보 조회 실패 : " + e.getMessage(), e.getStatus()));
    }

    @DeleteMapping("/{reservationInfoId}")
    public Mono<ResponseEntity<ApiResponse>> deleteReservationInfo(@Login UserInfo userInfo, @PathVariable Integer reservationInfoId){
        return reservationInfoService.deleteReservationInfo(userInfo,reservationInfoId)
                .flatMap(deletedId -> ApiResponse.ok("예약 정보 삭제 성공",deletedId))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("예약 정보 삭제 실패 : " + e.getMessage(),e.getStatus()));
    }

    @GetMapping
    public Mono<ResponseEntity<ApiResponse>> getMyReservationInfos(@Login UserInfo userInfo){
        Hooks.onOperatorDebug();
        return reservationInfoService.getReservationInfo(userInfo.getUserId())
                .flatMap(reservationDetailDtos -> ApiResponse.ok("예약 정보 조회 성공", reservationDetailDtos))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("예약 정보 조회 실패 : " + e.getMessage(), e.getStatus()));
    }

}
