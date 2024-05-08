package com.moass.api.domain.device.controller;


import com.moass.api.domain.device.dto.Coordinate;
import com.moass.api.domain.device.dto.DeviceIdDto;
import com.moass.api.domain.device.dto.ReqDeviceLoginDto;
import com.moass.api.domain.device.service.DeviceService;
import com.moass.api.global.annotaion.Login;
import com.moass.api.global.auth.JWTService;
import com.moass.api.global.auth.dto.UserInfo;
import com.moass.api.global.exception.CustomException;
import com.moass.api.global.response.ApiResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Mono;

@Slf4j
@RestController
@RequestMapping("/device")
@RequiredArgsConstructor
public class DeviceController {

    final DeviceService deviceService;
    final JWTService jwtService;

    @PostMapping("/login")
    public Mono<ResponseEntity<ApiResponse>> login(@RequestBody ReqDeviceLoginDto reqDeviceLoginDto) {
        return deviceService.deviceLogin(reqDeviceLoginDto)
                .flatMap(tokens -> ApiResponse.ok("로그인 성공",tokens))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("로그인 실패 : " + e.getMessage(), e.getStatus()));
    }

    @PostMapping("/logout")
    public Mono<ResponseEntity<ApiResponse>> logout(@Login UserInfo userInfo) {
        return deviceService.deviceLogout(userInfo)
                .flatMap(deviceId -> ApiResponse.ok("로그아웃 성공",deviceId))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("로그아웃 실패 : " + e.getMessage(), e.getStatus()));
    }

    @GetMapping("/islogin")
    public Mono<ResponseEntity<ApiResponse>> login(@RequestBody DeviceIdDto deviceIdDto) {
        return deviceService.isLogin(deviceIdDto)
                .flatMap(isLogin -> ApiResponse.ok("조회완료",isLogin))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("로그인 실패 : " + e.getMessage(), e.getStatus()));
    }

    @PatchMapping("/coordinate/{deviceId}")
    public Mono<ResponseEntity<ApiResponse>> updateDeviceCoordinates(
            @PathVariable String deviceId,
            @RequestBody Coordinate coordinate) {
        log.info("updateDeviceCoordinates : {}", coordinate);
    return deviceService.updateDeviceCoordinates(deviceId,coordinate)
            .flatMap(device -> ApiResponse.ok("좌표 업데이트 성공", device))
            .onErrorResume(CustomException.class, e -> ApiResponse.error("좌표 업데이트 실패 : " + e.getMessage(), e.getStatus()));
    }


}
