package com.moass.api.domain.oauth2.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.moass.api.domain.oauth2.dto.JiraProxyRequestDto;
import com.moass.api.domain.oauth2.dto.TokenResponseDto;
import com.moass.api.domain.oauth2.entity.JiraToken;
import com.moass.api.domain.oauth2.repository.JiraTokenRepository;
import com.moass.api.global.auth.dto.UserInfo;
import com.moass.api.global.config.PropertiesConfig;
import com.moass.api.global.exception.CustomException;
import io.netty.channel.ChannelOption;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.client.reactive.ReactorClientHttpConnector;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.ExchangeStrategies;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;
import reactor.core.scheduler.Schedulers;
import reactor.netty.http.client.HttpClient;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
public class Oauth2JiraService {

    private final WebClient jiraAuthWebClient;

    private final WebClient jiraApiWebClient;
    private final JiraTokenRepository jiraTokenRepository;
    private final PropertiesConfig propertiesConfig;

    public Oauth2JiraService(WebClient jiraAuthWebClient, WebClient jiraApiWebClient, JiraTokenRepository jiraTokenRepository, PropertiesConfig propertiesConfig) {
        this.jiraAuthWebClient = jiraAuthWebClient;
        this.jiraApiWebClient = jiraApiWebClient;
        this.jiraTokenRepository = jiraTokenRepository;
        this.propertiesConfig = propertiesConfig;
    }



    public Mono<JiraToken> exchangeCodeForToken(String code, String state) {
        return jiraAuthWebClient.post()
                .uri("/oauth/token")
                .bodyValue(prepareTokenRequest(code))
                .retrieve()
                .bodyToMono(TokenResponseDto.class)
                .flatMap(response -> storeTokenAndCloudId(state, response));
    }

    private Mono<JiraToken> storeTokenAndCloudId(String userId, TokenResponseDto response) {
        return jiraApiWebClient.get()
                .uri("/oauth/token/accessible-resources")
                .header("Authorization", "Bearer " + response.getAccessToken())
                .retrieve()
                .bodyToMono(List.class)
                .timeout(Duration.ofSeconds(10)) // 타임아웃 설정
                .doOnError(throwable -> log.error("cloudId를 가져오는 중 오류 발생", throwable))
                .flatMap(resources -> {
                    String cloudId = extractCloudId(resources);
                    if (cloudId == null) {
                        return Mono.error(new RuntimeException("cloudId를 가져오는데 실패했습니다."));
                    }
                    return jiraApiWebClient.get()
                            .uri(String.format("/ex/jira/%s/rest/api/3/myself", cloudId))
                            .header("Authorization", "Bearer " + response.getAccessToken())
                            .retrieve()
                            .bodyToMono(JsonNode.class)
                            .timeout(Duration.ofSeconds(10))
                            .doOnError(throwable -> log.error("사용자 정보를 가져오는 중 오류 발생", throwable))
                            .flatMap(userInfo -> {
                                String emailAddress = userInfo.path("emailAddress").asText();

                                return jiraTokenRepository.findByUserId(userId)
                                        .flatMap(existingToken -> {
                                            existingToken.setCloudId(cloudId);
                                            existingToken.setJiraEmail(emailAddress);
                                            existingToken.setAccessToken(response.getAccessToken());
                                            existingToken.setRefreshToken(response.getRefreshToken());
                                            existingToken.setExpiresAt(LocalDateTime.now().plusHours(1)); // 만료 시간 설정
                                            return jiraTokenRepository.save(existingToken);
                                        })
                                        .switchIfEmpty(Mono.defer(() -> {
                                            JiraToken newToken = JiraToken.builder()
                                                    .userId(userId)
                                                    .cloudId(cloudId)
                                                    .jiraEmail(emailAddress)
                                                    .accessToken(response.getAccessToken())
                                                    .refreshToken(response.getRefreshToken())
                                                    .expiresAt(LocalDateTime.now().plusHours(1)) // 만료 시간 설정
                                                    .build();

                                            return jiraTokenRepository.save(newToken);
                                        }));
                            });
                })
                .subscribeOn(Schedulers.boundedElastic())
                .timeout(Duration.ofSeconds(10))
                .doOnError(error -> log.error("jira 연결 에러: {}", error.getMessage()))
                .doOnTerminate(() -> log.info("jira 연결 완료"));
    }

    private String extractCloudId(List<Map<String, Object>> resources) {
        if (resources.isEmpty()) {
            return null;
        }
        return (String) resources.get(0).get("id");
    }

    private Map<String, Object> prepareTokenRequest(String code) {
        Map<String, Object> formData = new HashMap<>();
        formData.put("grant_type", "authorization_code");
        formData.put("client_id", propertiesConfig.getJiraClientId());
        formData.put("client_secret", propertiesConfig.getJiraClientSecret());
        formData.put("code", code);
        formData.put("redirect_uri", propertiesConfig.getJiraRedirectUri());
        return formData;
    }

    public Mono<JiraToken> getTokenByUserId(String userId) {
        return jiraTokenRepository.findByUserId(userId)
                .flatMap(token -> {
                    if (token.getExpiresAt().isBefore(LocalDateTime.now())) {
                        return refreshAccessToken(token)
                                .flatMap(refreshedToken -> jiraTokenRepository.save(refreshedToken));
                    } else {
                        return Mono.just(token);
                    }
                })
                .switchIfEmpty(Mono.error(new CustomException("연동된 Jira 계정이 없습니다.", HttpStatus.FORBIDDEN)));
    }

    private Map<String, Object> prepareRefreshTokenRequest(String refreshToken) {
        Map<String, Object> formData = new HashMap<>();
        formData.put("grant_type", "refresh_token");
        formData.put("client_id", propertiesConfig.getJiraClientId());
        formData.put("client_secret", propertiesConfig.getJiraClientSecret());
        formData.put("refresh_token", refreshToken);
        return formData;
    }

    private Mono<JiraToken> refreshAccessToken(JiraToken token) {
        return jiraAuthWebClient.post()
                .uri("/oauth/token")
                .bodyValue(prepareRefreshTokenRequest(token.getRefreshToken()))
                .retrieve()
                .bodyToMono(TokenResponseDto.class)
                .flatMap(response -> {
                    JiraToken refreshedToken = JiraToken.builder()
                            .jiraTokenId(token.getJiraTokenId())
                            .userId(token.getUserId())
                            .cloudId(token.getCloudId())
                            .jiraEmail(token.getJiraEmail())
                            .accessToken(response.getAccessToken())
                            .refreshToken(response.getRefreshToken() != null ? response.getRefreshToken() : token.getRefreshToken())
                            .expiresAt(LocalDateTime.now().plusHours(1))
                            .build();

                    return Mono.just(refreshedToken);
                });
    }


    public Mono<String> getJiraConnectUrl(UserInfo userInfo) {
        return Mono.just("https://auth.atlassian.com" +
                "/authorize?audience=api.atlassian.com&client_id=" +
                propertiesConfig.getJiraClientId() +
                "&scope=offline_access%20read%3Ajira-user%20read%3Ajira-work%20write%3Ajira-work&redirect_uri=" +
                propertiesConfig.getJiraRedirectUri() + "&state=" + userInfo.getUserId() + "&response_type=code&prompt=consent");
    }

    public Mono<JiraToken> deleteJiraConnect(UserInfo userInfo) {
        return jiraTokenRepository.findByUserId(userInfo.getUserId())
                .flatMap(token -> jiraTokenRepository.delete(token)
                        .then(Mono.just(token)))
                .switchIfEmpty(Mono.error(new CustomException("연동된 Jira 계정이 없습니다.", HttpStatus.FORBIDDEN)));
    }

    public Mono<JsonNode> proxyRequestToJira(String userId, JiraProxyRequestDto jiraProxyRequestDto) {
        return getTokenByUserId(userId)
                .flatMap(token -> {
                    if(token.getUserId()==null){
                        return Mono.error(new CustomException("토큰이 없습니다.", HttpStatus.UNAUTHORIZED));
                    }
                    String fullUrl = String.format("/ex/jira/%s%s", token.getCloudId(), jiraProxyRequestDto.getUrl());
                    WebClient.RequestHeadersSpec<?> requestSpec;

                    switch (jiraProxyRequestDto.getMethod().toUpperCase()) {
                        case "POST":
                            requestSpec = jiraApiWebClient.post()
                                    .uri(fullUrl)
                                    .header("Authorization", "Bearer " + token.getAccessToken())
                                    .header("Content-Type", "application/json")
                                    .body(BodyInserters.fromValue(jiraProxyRequestDto.getBody()));
                            break;
                        case "GET":
                        default:
                            requestSpec = jiraApiWebClient.get()
                                    .uri(fullUrl)
                                    .header("Authorization", "Bearer " + token.getAccessToken());
                            break;
                    }

                    return requestSpec.retrieve()
                            .onStatus(status -> !status.is2xxSuccessful(), clientResponse -> clientResponse.bodyToMono(String.class)
                                    .flatMap(errorBody -> Mono.error(new CustomException(
                                            String.format("내부 서버 에러: %s from %s %s",
                                                    clientResponse.statusCode(),
                                                    jiraProxyRequestDto.getMethod(),
                                                    fullUrl),
                                            HttpStatus.INTERNAL_SERVER_ERROR
                                    ))))
                            .bodyToMono(JsonNode.class)
                            .timeout(Duration.ofSeconds(10))
                            .doOnError(throwable -> log.error("지라 프록시중 에러발생", throwable))
                            .switchIfEmpty(Mono.empty());
                });
    }

    public Mono<String> isConnected(String userId) {
        return jiraTokenRepository.findByUserId(userId)
                .flatMap(token -> {
                    if (token.getJiraEmail() != null) {
                        return Mono.just(token.getJiraEmail());
                    } else {
                        return Mono.error(new CustomException("Jira 이메일이 없습니다.", HttpStatus.FORBIDDEN));
                    }
                })
                .switchIfEmpty(Mono.error(new CustomException("Jira 토큰이 없습니다.", HttpStatus.FORBIDDEN)));
    }

}
