package com.moass.api.domain.oauth2.repository;

import com.moass.api.domain.oauth2.entity.GitlabToken;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import reactor.core.publisher.Mono;

public interface GitlabTokenRepository  extends ReactiveCrudRepository<GitlabToken, Integer> {
    Mono<GitlabToken> findByUserId(String userId);
}
