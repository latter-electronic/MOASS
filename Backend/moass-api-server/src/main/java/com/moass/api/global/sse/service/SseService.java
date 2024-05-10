package com.moass.api.global.sse.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.moass.api.domain.notification.dto.NotificationSendDto;
import com.moass.api.domain.notification.service.NotificationService;
import com.moass.api.domain.user.repository.SsafyUserRepository;
import com.moass.api.domain.user.repository.UserRepository;
import com.moass.api.global.auth.dto.UserInfo;
import com.moass.api.global.sse.dto.SseNotificationDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import reactor.core.publisher.*;

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

    private int sseCount=0;
    private final ObjectMapper objectMapper = new ObjectMapper();

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
                                    sink.tryEmitNext("개인채널 구독 완료 : "+userInfo.getUserId());
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
                                log.info("Subscribing to team: " + teamCode + " by user: " + userInfo.getUserId());
                                sink.tryEmitNext("팀채널 구독 완료 : " + teamCode);
                            })
                            .doFinally(signalType -> {
                                log.info("Subscription ended or cancelled for team: " + teamCode + " by user: " + userInfo.getUserId());
                                if (sink.currentSubscriberCount() == 0) {
                                    log.info("Removing sink for team: " + teamCode);
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
    public Mono<Boolean> notifyUser(String userId, SseNotificationDto message) {
        return Mono.fromCallable(() -> {
            Sinks.Many<String> sink = userSinks.get(userId);
            if (sink != null) {
                boolean result = sink.tryEmitNext(createSseJsonMessage(message)).isSuccess();
                if (!result) {
                    log.error("유저 SSE전송 실패 : " + userId);
                }
                return result;
            }
            log.error("활성화된 유저 없습니다. : " + userId);
            return false;
        });
    }

    public Mono<Boolean> notifyTeam(String teamCode, String message) {
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
            String json = objectMapper.registerModule(new JavaTimeModule()).writeValueAsString(data);
            return json;
        } catch (Exception e) {
            log.error("JSON 변환 실패", e);
            return "error! : "+e;
        }
    }

    @Scheduled(fixedRate = 10000)  // 10 seconds
    public void sendTestMessages() {
        log.info("userSinks size: {}", userSinks.size());
        log.info("teamSinks size: {}", teamSinks.size());
        log.info("classSinks size: {}", classSinks.size());
        Map<String,String> tmp= new HashMap<>();
        sseCount++;
        userSinks.forEach((userId, sink) -> {
            log.info("User ID '{}' has {} subscribers.", userId, sink.currentSubscriberCount());
            sink.tryEmitNext("Test message to user: " + userId);

        });

        // 각 팀에게 테스트 메시지 전송
        teamSinks.forEach((teamCode, sink) -> {
            log.info("Team code '{}' has {} subscribers.", teamCode, sink.currentSubscriberCount());
            sink.tryEmitNext("Test message to team: " + teamCode);
            sink.tryEmitNext(tmp.toString());
            //sink.tryEmitNext(jsonMessage).isSuccess();
        });

        // 각 반에게 테스트 메시지 전송
        classSinks.forEach((classCode, sink) -> {
            log.info("Class code '{}' has {} subscribers.", classCode, sink.currentSubscriberCount());
            sink.tryEmitNext("Test message to class: " + classCode);
        });
    }
}
