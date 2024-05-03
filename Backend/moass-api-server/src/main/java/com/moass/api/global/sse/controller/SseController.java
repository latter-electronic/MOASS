package com.moass.api.global.sse.controller;

import com.moass.api.global.annotaion.Login;
import com.moass.api.global.auth.dto.UserInfo;
import com.moass.api.global.response.ApiResponse;
import com.moass.api.global.sse.dto.MessageDto;
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
            @RequestParam(required = false) String teamCode,
            @RequestParam(required = false) String classCode,
            @RequestParam(required = false) String userId,
            @RequestBody MessageDto messageDto) {
        if (messageDto.getMessage() == null) {
            return ApiResponse.error("메시지가 필요합니다.", HttpStatus.NO_CONTENT);
        }

        if (teamCode != null) {
            return sseService.notifyTeam(teamCode, messageDto.getMessage())
                    .then(ApiResponse.ok("팀 메시지 전송 완료"));
        } else if (classCode != null) {
            return sseService.notifyClass(classCode, messageDto.getMessage())
                    .then(ApiResponse.ok("반 메시지 전송 완료"));
        } else if (userId != null) {
            return sseService.notifyUser(userId, messageDto.getMessage())
                    .then(ApiResponse.ok("사용자 메시지 전송 완료"));
        } else {
            return ApiResponse.error("팀 코드, 반 코드 또는 사용자 ID 중 하나가 필요합니다.", HttpStatus.BAD_REQUEST);
        }
    }
}