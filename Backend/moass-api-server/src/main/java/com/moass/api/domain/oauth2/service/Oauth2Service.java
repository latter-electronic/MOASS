package com.moass.api.domain.oauth2.service;

import com.moass.api.domain.oauth2.dto.TokenResponseDto;
import com.moass.api.domain.oauth2.entity.JiraToken;
import com.moass.api.domain.oauth2.repository.JiraTokenRepository;
import com.moass.api.global.auth.dto.UserInfo;
import com.moass.api.global.config.PropertiesConfig;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
public class Oauth2Service {

    private final WebClient jiraAuthWebClient;

    private final WebClient jiraApiWebClient;
    private final JiraTokenRepository jiraTokenRepository;
    private final PropertiesConfig propertiesConfig;
    public Oauth2Service(WebClient.Builder webClientBuilder, JiraTokenRepository jiraTokenRepository, PropertiesConfig propertiesConfig) {
        this.jiraAuthWebClient = webClientBuilder.baseUrl("https://auth.atlassian.com").build();
        this.jiraApiWebClient = webClientBuilder.baseUrl("https://api.atlassian.com").build();
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
                .flatMap(resources -> {
                    String cloudId = extractCloudId(resources);
                    if (cloudId == null) {
                        return Mono.error(new RuntimeException("cloudId를 가져오는데 실패했습니다."));
                    }

                    JiraToken token = JiraToken.builder()
                            .userId(userId)
                            .cloudId(cloudId)
                            .accessToken(response.getAccessToken())
                            .refreshToken(response.getRefreshToken())
                            .build();

                    return jiraTokenRepository.save(token);
                });
    }

    private String extractCloudId(List<Map<String, Object>> resources) {
        if (resources.isEmpty()) {
            return null;
        }
        return (String) resources.get(0).get("id");
    }

    private Mono<JiraToken> storeToken(String userId, TokenResponseDto response) {
        log.info(String.valueOf(response));
        JiraToken token = JiraToken.builder()
                .userId(userId)
                .accessToken(response.getAccessToken())
                .refreshToken(response.getRefreshToken())
                .build();

        return jiraTokenRepository.save(token);
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
        log.info("리프레시 시도");
        return jiraTokenRepository.findByUserId(userId)
                .flatMap(token -> {
                    log.info(String.valueOf(token.getExpiresAt()));
                    log.info(String.valueOf(LocalDateTime.now()));
                    if (token.getExpiresAt().isBefore(LocalDateTime.now().plusHours(9))) {
                        log.info("시간초과로 리프레쉬됨");
                        return refreshAccessToken(token)
                                .flatMap(refreshedToken -> jiraTokenRepository.save(refreshedToken));
                    } else {
                        return Mono.just(token);
                    }
                });
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
                            .accessToken(response.getAccessToken())
                            .refreshToken(response.getRefreshToken() != null ? response.getRefreshToken() : token.getRefreshToken())
                            .expiresAt(LocalDateTime.now().plusHours(10))
                            .build();

                    return Mono.just(refreshedToken);
                });
    }


    public Mono<String> getJiraConnectUrl(UserInfo userInfo) {
        return Mono.just("https://auth.atlassian.com"+
                "/authorize?audience=api.atlassian.com&client_id="+
                propertiesConfig.getJiraClientId()+
                "&scope=offline_access%20read%3Ajira-user%20read%3Ajira-work%20write%3Ajira-work&redirect_uri="+
                propertiesConfig.getJiraRedirectUri()+"&state="+userInfo.getUserId()+"&response_type=code&prompt=consent");
    }
}
