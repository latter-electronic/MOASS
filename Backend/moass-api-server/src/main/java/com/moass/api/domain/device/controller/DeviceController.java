package com.moass.api.domain.device.controller;


import com.moass.api.domain.device.dto.ReqDeviceLoginDto;
import com.moass.api.domain.device.dto.ReqDeviceLogoutDto;
import com.moass.api.domain.device.service.DeviceService;
import com.moass.api.domain.user.dto.UserLoginDto;
import com.moass.api.global.auth.CustomReactiveUserDetailsService;
import com.moass.api.global.auth.CustomUserDetails;
import com.moass.api.global.auth.JWTService;
import com.moass.api.global.auth.dto.UserInfo;
import com.moass.api.global.exception.CustomException;
import com.moass.api.global.response.ApiResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
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
    public Mono<ResponseEntity<ApiResponse>> logout(@RequestBody ReqDeviceLogoutDto reqDeviceLogoutDto) {
        return deviceService.deviceLogout(reqDeviceLogoutDto)
                .then(ApiResponse.ok("로그아웃 성공"))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("로그아웃 실패 : " + e.getMessage(), e.getStatus()));
    }
}
