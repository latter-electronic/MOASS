package com.moass.api.global.fcm.service;


import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.google.auth.oauth2.GoogleCredentials;
import com.moass.api.global.config.JsonConfig;
import com.moass.api.global.fcm.dto.FcmMessageDto;
import com.moass.api.global.fcm.dto.FcmNotificationDto;
import com.moass.api.global.fcm.dto.FcmTokenSaveDto;
import com.moass.api.global.fcm.entity.FcmToken;
import com.moass.api.global.fcm.repository.FcmRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.io.ClassPathResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.io.IOException;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class FcmService {
    private final FcmRepository fcmRepository;
    private final JsonConfig jsonConfig;
    private final WebClient webClient = WebClient.builder().build();
    public Mono<FcmToken> saveOrUpdateFcmToken(String userId, FcmTokenSaveDto fcmTokenSaveDto) {
        String mobileDeviceId = fcmTokenSaveDto.getMobileDeviceId();
        String fcmToken = fcmTokenSaveDto.getFcmToken();

        return fcmRepository.findByToken(fcmToken)
                .flatMap(existingUserWithToken -> {
                    existingUserWithToken.setToken(null);
                    return fcmRepository.save(existingUserWithToken);
                })
                .then(fcmRepository.findByUserIdAndMobileDeviceId(userId, mobileDeviceId)
                        .flatMap(existingToken -> {
                            existingToken.setToken(fcmToken);
                            return fcmRepository.save(existingToken);
                        })
                        .switchIfEmpty(Mono.defer(() -> {
                            FcmToken newToken = FcmToken.builder()
                                    .userId(userId)
                                    .mobileDeviceId(mobileDeviceId)
                                    .token(fcmToken)
                                    .build();
                            return fcmRepository.save(newToken);
                        })));
    }

    public Mono<Integer> sendMessageTo(String fcmToken, FcmNotificationDto fcmNotificationDto) {
        log.info(createMessage(fcmToken,fcmNotificationDto));
        return Mono.fromCallable(this::getAccessToken)
                .flatMap(token -> webClient.post()
                        .uri("https://fcm.googleapis.com/v1/projects/moass-b25d1/messages:send")
                        .header(HttpHeaders.AUTHORIZATION, "Bearer " + token)
                        .contentType(MediaType.APPLICATION_JSON)
                        .bodyValue(createMessage(fcmToken,fcmNotificationDto))
                        .retrieve()
                        .bodyToMono(String.class)
                        .doOnError(error -> log.error("FCM 메세지 전송 실패: {}", error.getMessage(), error))
                        .map(response -> 1)
                        .onErrorReturn(0));
    }


    private String getAccessToken() throws IOException {
        String firebaseConfigPath = "firebase-admin-sdk.json";
        GoogleCredentials googleCredentials = GoogleCredentials
                .fromStream(new ClassPathResource(firebaseConfigPath).getInputStream())
                .createScoped(List.of("https://www.googleapis.com/auth/cloud-platform"));
        googleCredentials.refreshIfExpired();
        return googleCredentials.getAccessToken().getTokenValue();
    }


    private String createMessage(String fcmToken, FcmNotificationDto fcmNotificationDto) {
        ObjectMapper objectMapper = jsonConfig.objectMapper();
        FcmMessageDto fcmMessageDto = FcmMessageDto.builder()
                .message(FcmMessageDto.Message.builder()
                        .token(fcmToken)
                        .notification(FcmMessageDto.Notification.builder()
                                .title(fcmNotificationDto.getTitle())
                                .body(fcmNotificationDto.getBody())
                                .build())
                        .data(fcmNotificationDto)
                        .build())
                .validateOnly(false)
                .build();
        try {
            log.info(fcmMessageDto.toString());
            return objectMapper.writeValueAsString(fcmMessageDto);
        } catch (JsonProcessingException e) {
            throw new RuntimeException("FCM 메세지 생성실패", e);
        }
    }

    public Mono<Integer> sendMessageToUser(String userId, FcmNotificationDto fcmNotificationDto) {
        return fcmRepository.findAllByUserId(userId)
                .flatMap(fcmToken -> sendMessageTo(fcmToken.getToken(), fcmNotificationDto))
                .collectList()
                .map(resultList -> (int) resultList.stream().filter(result -> result == 1).count());
    }

    public Mono<Integer> sendMessageToTeam(String teamCode,  FcmNotificationDto fcmNotificationDto) {
        return findFcmTokensByteamCode(teamCode)
                .flatMap(fcmToken -> sendMessageTo(fcmToken.getToken(),fcmNotificationDto))
                .collectList()
                .map(resultList -> {
                    long successCount = resultList.stream().filter(result -> result == 1).count();
                    return (int) successCount;
                });
    }

    public Flux<FcmToken> findFcmTokensByteamCode(String teamCode) {
        return fcmRepository.findAllByteamCode(teamCode)
                .collectList()
                .flatMapMany(Flux::fromIterable);
    }
}
