package com.moass.api.global.sse.service;

import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;
import reactor.core.publisher.FluxSink;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class SseService {

    private final Map<String, List<FluxSink<String>>> userSinks = new ConcurrentHashMap<>();
    private final Map<String, List<FluxSink<String>>> teamSinks = new ConcurrentHashMap<>();
    private final Map<String, List<FluxSink<String>>> classSinks = new ConcurrentHashMap<>();


    public Flux<String> subscribeUser(String teamCode) {
        return Flux.create(sink -> {
            userSinks.computeIfAbsent(teamCode, k -> new ArrayList<>()).add(sink);
            sink.next(teamCode + " 개인 채널 구독");
            sink.onDispose(() -> {
                userSinks.get(teamCode).remove(sink);
                if (userSinks.get(teamCode).isEmpty()) {
                    userSinks.remove(teamCode);
                }
            });
        }, FluxSink.OverflowStrategy.LATEST);
    }

    // 팀 구독 메소드
    public Flux<String> subscribeTeam(String teamCode) {
        return Flux.create(sink -> {
            teamSinks.computeIfAbsent(teamCode, k -> new ArrayList<>()).add(sink);
            sink.next(teamCode + " 팀 채널 구독");
            sink.onDispose(() -> {
                teamSinks.get(teamCode).remove(sink);
                if (teamSinks.get(teamCode).isEmpty()) {
                    teamSinks.remove(teamCode);
                }
            });
        }, FluxSink.OverflowStrategy.LATEST);
    }

    // 반 구독 메소드
    public Flux<String> subscribeClass(String classCode) {
        return Flux.create(sink -> {
            classSinks.computeIfAbsent(classCode, k -> new ArrayList<>()).add(sink);
            sink.next(classCode + " 반 채널 구독");
            sink.onDispose(() -> {
                classSinks.get(classCode).remove(sink);
                if (classSinks.get(classCode).isEmpty()) {
                    classSinks.remove(classCode);
                }
            });
        }, FluxSink.OverflowStrategy.LATEST);
    }

    // 사람에게 알림 보내기
    public void notifyUser(String userId, String message) {
        if (teamSinks.containsKey(userId)) {
            List<FluxSink<String>> sinks = teamSinks.get(userId);
            for (FluxSink<String> sink : sinks) {
                sink.next(message);
            }
        }
    }

    // 팀에게 알림 보내기
    public void notifyTeam(String teamCode, String message) {
        if (teamSinks.containsKey(teamCode)) {
            List<FluxSink<String>> sinks = teamSinks.get(teamCode);
            for (FluxSink<String> sink : sinks) {
                sink.next(message);
            }
        }
    }

    // 반에 알림보내기
    public void notifyClass(String classCode, String message) {
        if (classSinks.containsKey(classCode)) {
            List<FluxSink<String>> sinks = userSinks.get(classCode);
            for (FluxSink<String> sink : sinks) {
                sink.next(message);
            }
        }
    }
}
