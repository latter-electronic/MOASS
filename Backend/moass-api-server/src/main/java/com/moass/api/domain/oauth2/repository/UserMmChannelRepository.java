package com.moass.api.domain.oauth2.repository;

import com.moass.api.domain.oauth2.entity.MMTeam;
import com.moass.api.domain.oauth2.entity.UserMMChannel;
import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

public interface UserMmChannelRepository extends ReactiveCrudRepository<UserMMChannel, String> {
    Mono<Boolean> existsByUserIdAndMmChannelId(String userId, String mmChannelId);

    Mono<Void> deleteByUserIdAndMmChannelId(String userId, String channelId);

    Flux<UserMMChannel> findByMmChannelId(String channelId);

    @Query("DELETE FROM UserMMChannel WHERE user_id = :userId")
    Mono<Void> deleteByUserId(String userId);
}
