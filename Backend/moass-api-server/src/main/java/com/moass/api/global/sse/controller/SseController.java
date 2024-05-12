package com.moass.api.global.sse.controller;

import com.moass.api.global.annotaion.Login;
import com.moass.api.global.auth.dto.UserInfo;
import com.moass.api.global.response.ApiResponse;
import com.moass.api.global.sse.dto.MessageDto;
import com.moass.api.global.sse.dto.SseNotificationDto;
import com.moass.api.global.sse.service.SseService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.http.codec.ServerSentEvent;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@Slf4j
@RestController
@RequestMapping("/stream")
@RequiredArgsConstructor
public class SseController {

    private final SseService sseService;

    @GetMapping("/class")
    public Flux<ServerSentEvent<String>> streamClassEvents(@Login UserInfo userInfo) {
        return sseService.subscribeClass(userInfo)
                .map(data -> ServerSentEvent.builder(data).build());
    }

    // 팀 코드별로 SSE 스트림 구독
    @GetMapping("/team")
    public Flux<ServerSentEvent<String>> streamTeamEvents(@Login UserInfo userInfo) {
        return sseService.subscribeTeam(userInfo)
                .map(data -> ServerSentEvent.builder(data).build());
    }

    // 개인 사용자의 이벤트 스트림 구독
    @GetMapping("/user")
    public Flux<ServerSentEvent<String>> streamUserEvents(@Login UserInfo userInfo) {
        return sseService.subscribeUser(userInfo)
                .map(data -> ServerSentEvent.builder(data).build());
    }


    @PostMapping("/send")
    public Mono<ResponseEntity<ApiResponse>> sendMessage(
            @RequestParam(required = false, name="teamcode") String teamCode,
            @RequestParam(required = false, name="classcode") String classCode,
            @RequestParam(required = false, name="userid") String userId,
            @RequestBody MessageDto messageDto) {
        if (messageDto.getMessage() == null) {
            return ApiResponse.error("메시지가 필요합니다.", HttpStatus.NO_CONTENT);
        }

        Mono<Boolean> notificationResult;
        if (teamCode != null) {
            notificationResult = sseService.notifyTeam(teamCode,  new SseNotificationDto("server","title","message"));
        } else if (classCode != null) {
            notificationResult = sseService.notifyClass(classCode, messageDto.getMessage());
        } else if (userId != null) {
            notificationResult = sseService.notifyUser(userId, new SseNotificationDto("server","title","message"));
        } else {
            return ApiResponse.error("팀 코드, 반 코드 또는 사용자 ID 중 하나가 필요합니다.", HttpStatus.BAD_REQUEST);
        }
        return notificationResult
                .flatMap(success -> {
                    if (success) {
                        return ApiResponse.ok("메시지 전송 성공");
                    } else {
                        return ApiResponse.error("메시지 전송 실패", HttpStatus.INTERNAL_SERVER_ERROR);
                    }
                })
                .onErrorResume(e -> ApiResponse.error("내부 서버 오류: " + e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR));
    }
}