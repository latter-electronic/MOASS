package com.moass.api.domain.oauth2.repository;

import com.moass.api.domain.oauth2.entity.MMToken;
import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import reactor.core.publisher.Mono;

public interface MmTokenRepository  extends ReactiveCrudRepository<MMToken, String> {
    @Query("SELECT * FROM MMToken WHERE user_id = :userId")
    Mono<MMToken> findByUserId(String userId);

    @Query("DELETE FROM MMToken WHERE user_id = :userId")
    Mono<Void> deleteByUserId(String userId);
}
