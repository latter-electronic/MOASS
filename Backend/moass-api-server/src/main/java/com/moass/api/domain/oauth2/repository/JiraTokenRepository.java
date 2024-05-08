package com.moass.api.domain.oauth2.repository;

import com.moass.api.domain.oauth2.entity.JiraToken;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import reactor.core.publisher.Mono;

public interface JiraTokenRepository   extends ReactiveCrudRepository<JiraToken, Integer> {
    Mono<JiraToken> findByUserId(String userId);
}
