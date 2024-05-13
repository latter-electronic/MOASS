package com.moass.api.domain.notification.controller;

import com.moass.api.domain.notification.dto.NotificationSendDto;
import com.moass.api.domain.notification.service.NotificationService;
import com.moass.api.global.annotaion.Login;
import com.moass.api.global.auth.dto.UserInfo;
import com.moass.api.global.exception.CustomException;
import com.moass.api.global.response.ApiResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Mono;

import java.time.LocalDateTime;


@Slf4j
@RestController
@RequestMapping("/notification")
@RequiredArgsConstructor
public class NotificationController {

    private final NotificationService notificationService;


    // 모든 알림 가져오기
    @GetMapping("/search")
    public Mono<ResponseEntity<ApiResponse>> getAllNotifications(@Login UserInfo userInfo,
                                                                 @RequestParam(defaultValue = "",name="lastnotificationid") String lastNotificationId,
                                                                 @RequestParam(required = false,name="lastcreatedat") LocalDateTime lastCreatedAt) {
        return notificationService.getAllNotifications(userInfo, lastNotificationId, lastCreatedAt)
                .flatMap(notifications -> ApiResponse.ok("알람 목록 조회 완료", notifications))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("조회 실패 : " + e.getMessage(), e.getStatus()));
    }

    @PreAuthorize("hasRole('ADMIN') or hasRole('CONSULTANT') or hasRole('COACH')")
    @PostMapping("/send")
    public Mono<ResponseEntity<ApiResponse>> saveNotification(@RequestParam(required=false,name = "userid") String userId,
                                                                                                                        @RequestParam(required=false, name="teamcode") String teamCode,
                                                                                                                        @RequestParam(required=false, name="classcode") String classCode,
                                                                                                                        @RequestBody NotificationSendDto notificationSendDto) {

        if(userId!=null) {
            return notificationService.saveAndPushNotification(userId, notificationSendDto)
                    .flatMap(savedNotification -> ApiResponse.ok("Notification 저장 성공", savedNotification))
                    .onErrorResume(CustomException.class, e -> ApiResponse.error("Notification 저장 실패 : " + e.getMessage(), e.getStatus()));
        }else if(teamCode!=null) {
            return notificationService.saveAndPushbyTeam(teamCode, notificationSendDto)
                    .flatMap(savedNotification -> ApiResponse.ok("Notification 저장 성공", savedNotification))
                    .onErrorResume(CustomException.class, e -> ApiResponse.error("Notification 저장 실패 : " + e.getMessage(), e.getStatus()));
        }else if(classCode!=null) {
            return notificationService.saveAndPushbyClass(classCode, notificationSendDto)
                    .flatMap(savedNotification -> ApiResponse.ok("Notification 저장 성공", savedNotification))
                    .onErrorResume(CustomException.class, e -> ApiResponse.error("Notification 저장 실패 : " + e.getMessage(), e.getStatus()));
        }
        return ApiResponse.error("userId, teamCode, classCode 중 하나는 필수입니다.", HttpStatus.BAD_REQUEST);
    }

    @DeleteMapping("/{notificationId}")
    public Mono<ResponseEntity<ApiResponse>> readNotification(@Login UserInfo userInfo,@PathVariable String notificationId){
        return notificationService.readNotification(userInfo,notificationId)
                .flatMap(readNotificationId -> ApiResponse.ok("알람 읽기완료", readNotificationId))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("조회 실패 : " + e.getMessage(), e.getStatus()));
    }

    @DeleteMapping("/read-all")
    public Mono<ResponseEntity<ApiResponse>> markAllNotificationsAsRead(@Login UserInfo userInfo) {
        return notificationService.markAllNotificationsAsRead(userInfo)
                .flatMap(count -> ApiResponse.ok("모든 알림을 읽음 처리했습니다.", count))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("알림 읽기 처리 실패 : " + e.getMessage(), e.getStatus()));
    }

}
