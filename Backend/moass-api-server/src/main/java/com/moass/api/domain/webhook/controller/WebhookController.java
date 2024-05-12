package com.moass.api.domain.webhook.controller;


import com.moass.api.domain.webhook.service.WebhookService;
import com.moass.api.global.annotaion.Login;
import com.moass.api.global.auth.dto.UserInfo;
import com.moass.api.global.exception.CustomException;
import com.moass.api.global.response.ApiResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Mono;

@Slf4j
@RestController
@RequestMapping("/webhook")
@RequiredArgsConstructor
public class WebhookController {

    private final WebhookService webhookService;
    @PostMapping("/gitlab")
    public Mono<ResponseEntity<ApiResponse>> refreshToken(@RequestBody String dd) {
        log.info(dd);
        return ApiResponse.ok("Gitlab Webhook Success");
    }

}
