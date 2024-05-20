package com.moass.api.global.sse.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.moass.api.domain.user.repository.SsafyUserRepository;
import com.moass.api.domain.user.repository.UserRepository;
import com.moass.api.global.auth.dto.UserInfo;
import com.moass.api.global.config.JsonConfig;
import com.moass.api.global.sse.dto.SseNotificationDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import reactor.core.publisher.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import reactor.core.publisher.Sinks;

import java.lang.management.ManagementFactory;
import java.lang.management.MemoryMXBean;
import java.lang.management.MemoryUsage;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Slf4j
@Service
@RequiredArgsConstructor
public class SseService {

    private final Map<String, Sinks.Many<String>> userSinks = new ConcurrentHashMap<>();
    private final Map<String, Sinks.Many<String>> teamSinks = new ConcurrentHashMap<>();
    private final Map<String, Sinks.Many<String>> classSinks = new ConcurrentHashMap<>();

    private final UserRepository userRepository;
    private final SsafyUserRepository ssafyUserRepository;

    private final JsonConfig jsonConfig;
    private int sseCount=0;

    public Mono<Boolean> userExists(String userId) {return userRepository.existsByUserId(userId);}
    public Mono<String> getTeamCode(String userId) {return ssafyUserRepository.findTeamCodeByUserId(userId);}

    public Mono<String> getClassCode(String userId) {return ssafyUserRepository.findClassCodeByUserId(userId);}
    public Flux<String> subscribeUser(UserInfo userInfo) {
        return userExists(userInfo.getUserId())
                .flatMapMany(exists -> {
                    if (exists) {
                        Sinks.Many<String> sink = userSinks.computeIfAbsent(userInfo.getUserId(), k -> Sinks.many().multicast().onBackpressureBuffer());
                        return sink.asFlux()
                                .doOnSubscribe(subscription -> {
                                    sink.tryEmitNext(createSseJsonMessage(new SseNotificationDto("server", "구독","유저채널 구독완료")));
                                })
                                .doFinally(signalType -> {
                                    if (sink.currentSubscriberCount() == 0) {
                                        userSinks.remove(userInfo.getUserId());
                                    }
                                });
                    } else {
                        return Flux.error(new RuntimeException("사용자 정보를 찾을 수 없습니다."));
                    }
                });
    }

    // 팀 구독 메소드
    public Flux<String> subscribeTeam(UserInfo userInfo) {
        return getTeamCode(userInfo.getUserId())
                .flatMapMany(teamCode -> {
                    if (teamCode == null || teamCode.isEmpty()) {
                        return Flux.error(new RuntimeException("팀 코드를 찾을 수 없습니다: " + userInfo.getUserId()));
                    }
                    Sinks.Many<String> sink = teamSinks.computeIfAbsent(teamCode, k -> Sinks.many().multicast().onBackpressureBuffer());
                    return sink.asFlux()
                            .doOnSubscribe(subscription -> {
                                sink.tryEmitNext(createSseJsonMessage(new SseNotificationDto("server", "구독","팀채널 구독완료")));
                            })
                            .doFinally(signalType -> {
                                if (sink.currentSubscriberCount() == 0) {
                                    teamSinks.remove(teamCode);
                                }
                            });
                });
    }


    public Flux<String> subscribeClass(UserInfo userInfo) {
        return getClassCode(userInfo.getUserId())
                .flatMapMany(classCode -> {
                    if (classCode == null || classCode.isEmpty()) {
                        return Flux.error(new RuntimeException("반 코드를 찾을 수 없습니다: " + userInfo.getUserId()));
                    }
                    Sinks.Many<String> sink = classSinks.computeIfAbsent(classCode, k -> Sinks.many().multicast().onBackpressureBuffer());
                    return sink.asFlux()
                            .doOnSubscribe(subscription -> {
                                sink.tryEmitNext("반채널 구독 완료 : "+classCode);
                            })
                            .doFinally(signalType -> {
                                if (sink.currentSubscriberCount() == 0) {
                                    classSinks.remove(classCode);
                                }
                            });

                });
    }

    // 사람에게 알림 보내기
    public Mono<Boolean> notifyUser(String userId, Object message) {
        return Mono.fromCallable(() -> {
            Sinks.Many<String> sink = userSinks.get(userId);
            if (sink != null) {
                boolean result = sink.tryEmitNext(createSseJsonMessage(message)).isSuccess();
                if (!result) {
                    log.error("유저 SSE전송 실패 : " + userId);
                }else{
                    log.info("유저 SSE 전송 성공 :"+userId);
                }
                return result;
            }
            log.error("활성화된 유저 없습니다. : " + userId);
            return false;
        });
    }

    public Mono<Boolean> notifyTeam(String teamCode, Object message) {
        return Mono.fromCallable(() -> {
            Sinks.Many<String> sink = teamSinks.get(teamCode);
            if (sink != null) {
                boolean result = sink.tryEmitNext(createSseJsonMessage(message)).isSuccess();
                if (!result) {
                    log.error("팀 SSE전송 실패 : " + teamCode);
                }
                return result;
            }
            log.error("활성화된 팀이 없습니다. : " + teamCode);
            return false;
        });
    }

    public Mono<Boolean> notifyClass(String classCode, String message) {
        return Mono.fromCallable(() -> {
            Sinks.Many<String> sink = classSinks.get(classCode);
            if (sink != null) {
                boolean result = sink.tryEmitNext(createSseJsonMessage(message)).isSuccess();
                if (!result) {
                    log.error("반 SSE전송 실패 : " + classCode);
                }
                return result;
            }
            log.error("활성화된 반이 없습니다. : " + classCode);
            return false;
        });
    }

    private String createSseJsonMessage(Object data) {
        try {
            ObjectMapper objectMapper = jsonConfig.nullableObjectMapper();
            String json = objectMapper.writeValueAsString(data);
            return json;
        } catch (Exception e) {
            log.error("JSON 변환 실패", e);
            return "error! : "+e;
        }
    }

    @Scheduled(fixedRate = 30000)  // 10 seconds
    public void sendTestMessages() {
        log.info("userSinks size: {}", userSinks.size());
        log.info("teamSinks size: {}", teamSinks.size());
        log.info("classSinks size: {}", classSinks.size());
        Map<String,String> tmp= new HashMap<>();
        sseCount++;
        userSinks.forEach((userId, sink) -> {
            log.info("User ID '{}' has {} subscribers.", userId, sink.currentSubscriberCount());
        });

        teamSinks.forEach((teamCode, sink) -> {
            log.info("Team code '{}' has {} subscribers.", teamCode, sink.currentSubscriberCount());
        });

        classSinks.forEach((classCode, sink) -> {
            log.info("Class code '{}' has {} subscribers.", classCode, sink.currentSubscriberCount());
        });
        MemoryMXBean memoryMXBean = ManagementFactory.getMemoryMXBean();
        MemoryUsage heapMemoryUsage = memoryMXBean.getHeapMemoryUsage();
        MemoryUsage nonHeapMemoryUsage = memoryMXBean.getNonHeapMemoryUsage();

        log.info("Heap Memory: Used={}MB, Max={}MB, Committed={}MB",
                bytesToMB(heapMemoryUsage.getUsed()),
                bytesToMB(heapMemoryUsage.getMax()),
                bytesToMB(heapMemoryUsage.getCommitted()));
        log.info("Non-Heap Memory: Used={}MB, Max={}MB, Committed={}MB",
                bytesToMB(nonHeapMemoryUsage.getUsed()),
                bytesToMB(nonHeapMemoryUsage.getMax()),
                bytesToMB(nonHeapMemoryUsage.getCommitted()));
    }
    private long bytesToMB(long bytes) {
        return bytes / (1024 * 1024);
    }
}
