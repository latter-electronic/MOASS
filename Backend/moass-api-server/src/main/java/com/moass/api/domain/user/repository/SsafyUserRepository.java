package com.moass.api.domain.user.repository;

import com.moass.api.domain.user.entity.SsafyUser;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import reactor.core.publisher.Mono;

public interface SsafyUserRepository extends ReactiveCrudRepository<SsafyUser, Integer> {

    Mono<SsafyUser> findByUserId(String userId);
}
