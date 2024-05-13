package com.moass.api.domain.webhook.controller;


import com.moass.api.domain.webhook.service.WebhookService;
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
@RequestMapping("/webhook")
@RequiredArgsConstructor
public class WebhookController {

    private final WebhookService webhookService;

    @PostMapping("/gitlab")
    public Mono<ResponseEntity<ApiResponse>> handleGitlabWebhook(@PathVariable String gitlabTokenId, @RequestBody String dd) {
        log.info("Received webhook data: {}", dd);
        return ApiResponse.ok("Gitlab Webhook Data Received Successfully");
    }

    @GetMapping("/gitlab")
    public Mono<ResponseEntity<ApiResponse>> generateWebhookIdentifier(@Login UserInfo userInfo) {
        return webhookService.createGitlabWebhookConnectUrl(userInfo)
                .flatMap(gitlabToken -> ApiResponse.ok("토큰생성 성공", gitlabToken))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("토큰생성 실패: "+e.getMessage(),e.getStatus()));
    }
}
