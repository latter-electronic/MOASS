package com.moass.api.domain.webhook.controller;


import com.moass.api.domain.notification.service.NotificationService;
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
    private final NotificationService notificationService;
    @PostMapping("/gitlab/{gitlabTokenId}")
    public Mono<ResponseEntity<ApiResponse>> handleGitlabWebhook(@PathVariable String gitlabTokenId, @RequestBody String payload) {
        log.info("Received webhook data: {}", payload);
        return webhookService.validateGitlabToken(gitlabTokenId)
                .flatMap(teamCode -> notificationService.processGitlabEvent(payload, teamCode))
                .flatMap(notification -> ApiResponse.ok("Gitlab Webhook Data Processed Successfully"))
                .onErrorResume(CustomException.class, e -> {
                    log.error("Error processing webhook: {}", e.getMessage());
                    return ApiResponse.error("Gitlab Webhook Data Processing Failed: " + e.getMessage(), e.getStatus());
                });
    }

    @GetMapping("/gitlab")
    public Mono<ResponseEntity<ApiResponse>> generateWebhookIdentifier(@Login UserInfo userInfo) {
        return webhookService.createGitlabWebhookConnectUrl(userInfo)
                .flatMap(gitlabToken -> ApiResponse.ok("토큰생성 성공", "api/"+gitlabToken))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("토큰생성 실패: "+e.getMessage(),e.getStatus()));
    }

    @PostMapping("/mm")
    public Mono<ResponseEntity<ApiResponse>> handleMattermostWebhook(@RequestBody String payload) {
        log.info("Received Mattermost webhook data: {}", payload);
        return notificationService.processMattermostEvent(payload)
                .flatMap(notification -> ApiResponse.ok("Mattermost Webhook Data Processed Successfully"))
                .onErrorResume(CustomException.class, e -> {
                    log.error("Error processing Mattermost webhook: {}", e.getMessage());
                    return ApiResponse.error("Mattermost Webhook Data Processing Failed: " + e.getMessage(), e.getStatus());
                });
    }
}
