package com.moass.api.domain.device.controller;


import com.moass.api.domain.device.dto.Coordinate;
import com.moass.api.domain.device.dto.DeviceIdDto;
import com.moass.api.domain.device.dto.ReqDeviceLoginDto;
import com.moass.api.domain.device.service.DeviceService;
import com.moass.api.domain.notification.dto.NotificationSendDto;
import com.moass.api.domain.notification.service.NotificationService;
import com.moass.api.global.annotaion.Login;
import com.moass.api.global.auth.JWTService;
import com.moass.api.global.auth.dto.UserInfo;
import com.moass.api.global.exception.CustomException;
import com.moass.api.global.response.ApiResponse;
import jakarta.validation.Valid;
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
    final NotificationService notificationService;
    @PostMapping("/login")
    public Mono<ResponseEntity<ApiResponse>> login(@RequestBody ReqDeviceLoginDto reqDeviceLoginDto) {
        return deviceService.deviceLogin(reqDeviceLoginDto)
                .flatMap(tokensAndUserInfo ->
                        notificationService.saveAndPushNotification(tokensAndUserInfo.getUserInfo().getUserId(), new NotificationSendDto("server", "기기 로그인", "기기에 연결되었습니다."))
                                .thenReturn(tokensAndUserInfo)
                )
                .flatMap(tokensAndUserInfo -> ApiResponse.ok("로그인 성공", tokensAndUserInfo.getTokens()))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("로그인 실패 : " + e.getMessage(), e.getStatus()));
    }

    @PostMapping("/logout")
    public Mono<ResponseEntity<ApiResponse>> logout(@Login UserInfo userInfo) {
        return deviceService.deviceLogout(userInfo)
                .flatMap(tokensAndUserInfo ->
                        notificationService.saveAndPushNotification(userInfo.getUserId(), new NotificationSendDto("server", "기기 로그아웃", "기기가 로그아웃되었습니다."))
                                .thenReturn(tokensAndUserInfo)
                )
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
            @Valid @RequestBody Coordinate coordinate) {
        log.info("updateDeviceCoordinates : {}", coordinate);
    return deviceService.updateDeviceCoordinates(deviceId,coordinate)
            .flatMap(device -> ApiResponse.ok("좌표 업데이트 성공", device))
            .onErrorResume(CustomException.class, e -> ApiResponse.error("좌표 업데이트 실패 : " + e.getMessage(), e.getStatus()));
    }


    @GetMapping("/search")
    public Mono<ResponseEntity<ApiResponse>> searchDevice(@Login UserInfo userInfo,
                                                     @RequestParam(name = "teamcode", required = false) String teamCode,
                                                     @RequestParam(name = "classcode", required = false) String classCode,
                                                     @RequestParam(name = "locationcode", required = false) String locationCode) {
        return deviceService.getClassInfo(classCode)
                .flatMap(classInfo -> ApiResponse.ok("조회완료", classInfo))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("반의 기기 조회 실패 : " + e.getMessage(), e.getStatus()));
    }

}
