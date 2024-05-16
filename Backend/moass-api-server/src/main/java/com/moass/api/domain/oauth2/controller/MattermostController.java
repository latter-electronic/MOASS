package com.moass.api.domain.oauth2.controller;


import com.moass.api.domain.oauth2.dto.MmLoginDto;
import com.moass.api.domain.oauth2.service.MattermostService;
import com.moass.api.global.annotaion.Login;
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
@RequestMapping("/oauth2/mm")
@RequiredArgsConstructor
public class MattermostController {

    private final MattermostService mattermostService;
    @PostMapping("/connect")
    public Mono<ResponseEntity<ApiResponse>> mmConnect(@Login UserInfo userInfo, @RequestBody MmLoginDto mmLoginDto){
        return mattermostService.mmConnect(userInfo,mmLoginDto)
                .flatMap(mmToken -> ApiResponse.ok("MM 로그인 성공", mmToken))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("예약 실패 : " + e.getMessage(), e.getStatus()));
    }

    /**
    @GetMapping("/channels")
    public Mono<ResponseEntity<ApiResponse>> getMyChannels(@Login UserInfo userInfo) {
        return mattermostService.getMyChannels(userInfo.getUserId())
                .flatMap(channels -> ApiResponse.ok("채널 정보 조회 성공", channels))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("채널 조회 실패 : " + e.getMessage(), e.getStatus()));
    }
    */
}
