package com.moass.api.domain.oauth2.controller;

import com.moass.api.domain.oauth2.service.Oauth2Service;
import com.moass.api.global.annotaion.Login;
import com.moass.api.global.auth.dto.UserInfo;
import com.moass.api.global.exception.CustomException;
import com.moass.api.global.response.ApiResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Mono;

@Slf4j
@RestController
@RequestMapping("/oauth2")
@RequiredArgsConstructor
public class Oauth2Controller {

    private final Oauth2Service oauth2Service;

    @GetMapping("/jira/connect")
    public Mono<ResponseEntity<ApiResponse>> jiraConnect(@Login UserInfo userInfo){
        return oauth2Service.getJiraConnectUrl(userInfo)
                .flatMap(jiraConnectUrl -> ApiResponse.ok("지라 연결주소 조회 성공", jiraConnectUrl))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("예약 실패 : " + e.getMessage(), e.getStatus()));
    }
    @GetMapping("/jira/callback")
    public Mono<ResponseEntity<ApiResponse>> jiraCallback(@RequestParam String code, @RequestParam String state){
        return oauth2Service.exchangeCodeForToken(code,state)
                .flatMap(token -> ApiResponse.ok("Jira 토큰 발급 성공", token))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("Jira 토큰 발급 실패 : " + e.getMessage(), e.getStatus()));
    }

    @GetMapping("/jira/refresh")
    public Mono<ResponseEntity<ApiResponse>> refreshToken(@Login UserInfo userInfo) {
        return oauth2Service.getTokenByUserId(userInfo.getUserId())
                .flatMap(token -> ApiResponse.ok("Jira 토큰 갱신 성공", token))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("Jira 토큰 갱신 실패 : " + e.getMessage(), e.getStatus()));
    }
}
