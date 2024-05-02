package com.moass.api.global.sse.controller;

import com.moass.api.global.sse.service.SseService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.codec.ServerSentEvent;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Flux;

@Slf4j
@RestController
@RequestMapping("/stream")
@RequiredArgsConstructor
public class SseController {

    private final SseService sseService;

    @GetMapping("/class/{classCode}")
    public Flux<ServerSentEvent<String>> streamClassEvents(@PathVariable String teamCode) {
        return sseService.subscribeClass(teamCode)
                .map(data -> ServerSentEvent.builder(data).build());
    }

    // 팀 코드별로 SSE 스트림 구독
    @GetMapping("/team/{teamCode}")
    public Flux<ServerSentEvent<String>> streamTeamEvents(@PathVariable String teamCode) {
        return sseService.subscribeTeam(teamCode)
                .map(data -> ServerSentEvent.builder(data).build());
    }

    // 개인 사용자의 이벤트 스트림 구독
    @GetMapping("/user/{userId}")
    public Flux<ServerSentEvent<String>> streamUserEvents(@PathVariable String userId) {
        return sseService.subscribeUser(userId)
                .map(data -> ServerSentEvent.builder(data).build());
    }
}