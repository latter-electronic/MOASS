package com.moass.api.domain.notification.controller;

import com.moass.api.domain.notification.dto.NotificationPageDto;
import com.moass.api.domain.notification.dto.NotificationSaveDto;
import com.moass.api.domain.notification.entity.Notification;
import com.moass.api.domain.notification.service.NotificationService;
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
@RequestMapping("/notification")
@RequiredArgsConstructor
public class NotificationController {

    private final NotificationService notificationService;


    // 모든 알림 가져오기
    @GetMapping("/all")
    public Mono<ResponseEntity<ApiResponse>> getAllNotifications(@Login UserInfo userInfo,@RequestParam(defaultValue = "1") int page) {
        return notificationService.getAllNotifications(userInfo,1)
                .flatMap(boards -> ApiResponse.ok("Board 목록 조회 완료", boards))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("조회 실패 : " + e.getMessage(), e.getStatus()));
    }

    @PostMapping("/send")
    public Mono<ResponseEntity<ApiResponse>> saveNotification(@RequestBody NotificationSaveDto notificationSaveDto) {
        return notificationService.saveNotification(notificationSaveDto)
                .flatMap(savedNotification -> ApiResponse.ok("Notification 저장 성공", savedNotification))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("Notification 저장 실패 : " + e.getMessage(), e.getStatus()));
    }

}
