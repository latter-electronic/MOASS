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
import org.springframework.http.HttpStatus;
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


    @GetMapping("/search")
    public Mono<ResponseEntity<ApiResponse>> searchDevice(@Login UserInfo userInfo,
                                                     @RequestParam(name = "teamcode", required = false) String teamCode,
                                                     @RequestParam(name = "classcode", required = false) String classCode,
                                                     @RequestParam(name = "locationcode", required = false) String locationCode) {
        return deviceService.getClassInfo(classCode)
                .flatMap(classInfo -> ApiResponse.ok("조회완료", classInfo))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("반의 기기 조회 실패 : " + e.getMessage(), e.getStatus()));
        /**
        int paramCount = 0;
        if (teamCode != null) paramCount++;
        if (classCode != null) paramCount++;
        if (locationCode != null) paramCount++;

        if (paramCount == 1) {
            if (teamCode != null) {

                return deviceService.getTeamInfo(teamCode)
                        .flatMap(team -> ApiResponse.ok("조회완료", team))
                        .switchIfEmpty(ApiResponse.ok("팀 조회 실패 : 해당 팀에 팀원이 존재하지 않습니다.", HttpStatus.NOT_FOUND))
                        .onErrorResume(CustomException.class, e -> ApiResponse.error("팀의 기기 조회 실패 : " + e.getMessage(), e.getStatus()));
            } else if (classCode != null) {
                return deviceService.getClassInfo(classCode)
                        .flatMap(classInfo -> ApiResponse.ok("조회완료", classInfo))
                        .onErrorResume(CustomException.class, e -> ApiResponse.error("반의 기기 조회 실패 : " + e.getMessage(), e.getStatus()));
            } else {
                return deviceService.getLocationInfo(locationCode)
                        .flatMap(locationInfo -> ApiResponse.ok("조회완료", locationInfo))
                        .onErrorResume(CustomException.class, e -> ApiResponse.error("지역의 기기 조회 실패 : " + e.getMessage(), e.getStatus()));
            }
        }else if(paramCount==0){
            return deviceService.getTeamInfo(userInfo.getTeamCode())
                    .flatMap(team -> ApiResponse.ok("조회완료", team))
                    .switchIfEmpty(ApiResponse.ok("팀 조회 실패 : 해당 팀에 기기가 존재하지 않습니다.", HttpStatus.NOT_FOUND)).onErrorResume(CustomException.class, e -> ApiResponse.error("팀 조회 실패 : " + e.getMessage(), e.getStatus()));
        }
        else {
            return ApiResponse.error("정확히 하나의 매개변수만 제공해야 합니다.", HttpStatus.BAD_REQUEST);
        }
         */
    }

}
