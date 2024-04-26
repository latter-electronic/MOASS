package com.moass.api.global.sse.service;

import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;
import reactor.core.publisher.FluxSink;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class SseService {

    private final Map<String, FluxSink<String>> teamSinks = new ConcurrentHashMap<>();
    private final Map<String, FluxSink<String>> userSinks = new ConcurrentHashMap<>();

    public Flux<String> subscribeTeam(String teamCode) {
        return Flux.create(sink -> {
            FluxSink<String> existingSink = teamSinks.putIfAbsent(teamCode, sink);
            if (existingSink == null) {
                sink.next(teamCode + " 구독");
                sink.onDispose(() -> teamSinks.remove(teamCode, sink)); // 연결 해제 시 자동으로 제거
            } else {
                sink.complete(); // 이미 구독 중인 경우 추가 작업 없이 완료
            }
        }, FluxSink.OverflowStrategy.LATEST);
    }

    public Flux<String> subscribeUser(String userId) {
        return Flux.create(sink -> {
            FluxSink<String> existingSink = userSinks.putIfAbsent(userId, sink);
            if (existingSink == null) {
                sink.next(userId + " 구독");
                sink.onDispose(() -> userSinks.remove(userId, sink)); // 연결 해제 시 자동으로 제거
            } else {
                sink.complete(); // 이미 구독 중인 경우 추가 작업 없이 완료
            }
        }, FluxSink.OverflowStrategy.LATEST);
    }

    public void notifyTeam(String teamCode, String message) {
        if (teamSinks.containsKey(teamCode)) {
            teamSinks.get(teamCode).next(message);
        }
    }

    public void notifyUser(String userId, String message) {
        if (userSinks.containsKey(userId)) {
            userSinks.get(userId).next(message);
        }
    }
}
