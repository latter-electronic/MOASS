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
        return Flux.create(sink -> teamSinks.put(teamCode, sink), FluxSink.OverflowStrategy.LATEST);
    }

    public Flux<String> subscribeUser(String userId) {
        return Flux.create(sink -> userSinks.put(userId, sink), FluxSink.OverflowStrategy.LATEST);
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
