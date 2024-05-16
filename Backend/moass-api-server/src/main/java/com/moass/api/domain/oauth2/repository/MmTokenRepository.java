package com.moass.api.domain.oauth2.repository;

import com.moass.api.domain.oauth2.entity.MMToken;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import reactor.core.publisher.Mono;

public interface MmTokenRepository  extends ReactiveCrudRepository<MMToken, String> {
    Mono<MMToken> findByUserId(String userId);
}
