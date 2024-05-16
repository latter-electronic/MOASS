package com.moass.api.domain.oauth2.service;

import com.moass.api.domain.oauth2.dto.MmLoginDto;
import com.moass.api.domain.oauth2.entity.MMToken;
import com.moass.api.domain.oauth2.repository.MmTokenRepository;
import com.moass.api.global.auth.dto.UserInfo;
import com.moass.api.global.config.PropertiesConfig;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.reactive.function.client.ClientResponse;
import org.springframework.web.reactive.function.client.ExchangeStrategies;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

import java.util.HashMap;
import java.util.Map;

@Slf4j
@Service
public class MattermostService {

    private final WebClient mmApiWebClient;
    private final PropertiesConfig propertiesConfig;

    private final MmTokenRepository mmTokenRepository;

    public MattermostService(WebClient.Builder webClientBuilder, PropertiesConfig propertiesConfig, MmTokenRepository mmTokenRepository) {
        this.mmTokenRepository = mmTokenRepository;
        ExchangeStrategies strategies = ExchangeStrategies.builder()
                .codecs(configurer -> configurer.defaultCodecs().maxInMemorySize(16 * 1024 * 1024)) // 16MB로 설정
                .build();
        this.mmApiWebClient = webClientBuilder.baseUrl("https://meeting.ssafy.com")
                .exchangeStrategies(strategies)
                .build();
        this.propertiesConfig = propertiesConfig;
    }

    @Transactional
    public Mono<MMToken> mmConnect(UserInfo userInfo, MmLoginDto mmLoginDto) {
        return mmApiWebClient.post()
                .uri("/api/v4/users/login")
                .bodyValue(prepareLoginRequest(mmLoginDto))
                .exchangeToMono(response -> saveOrUpdateToken(response, userInfo.getUserId()))
                .doOnError(error -> log.error("로그인 에러: {}", error.getMessage()))
                .flatMap(token -> Mono.just(token));
    }

    private Mono<MMToken> saveOrUpdateToken(ClientResponse response, String userId) {
        String token = response.headers().header("Token").get(0); // Token 헤더에서 토큰 추출
        return mmTokenRepository.findByUserId(userId)
                .flatMap(existingToken -> {
                    existingToken.setSessionToken(token);
                    return mmTokenRepository.save(existingToken);
                })
                .switchIfEmpty(Mono.defer(() -> {
                    MMToken newToken = new MMToken();
                    newToken.setUserId(userId);
                    newToken.setSessionToken(token);
                    return mmTokenRepository.save(newToken);
                }))
                .doOnSuccess(t -> log.info("Mattermost 토큰 저장 성공"))
                .doOnError(e -> log.error("Mattermost 토큰 저장 실패", e));
    }

    private Map<String, String> prepareLoginRequest(MmLoginDto mmLoginDto) {
        Map<String, String> formData = new HashMap<>();
        formData.put("login_id", mmLoginDto.getLoginId());
        formData.put("password", mmLoginDto.getPassword());
        return formData;
    }


}
