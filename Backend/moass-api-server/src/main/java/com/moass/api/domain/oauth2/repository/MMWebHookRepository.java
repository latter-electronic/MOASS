package com.moass.api.domain.oauth2.repository;

import com.moass.api.domain.oauth2.entity.MMWebHook;
import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import reactor.core.publisher.Mono;

public interface MMWebHookRepository extends ReactiveCrudRepository<MMWebHook, String> {

    @Query("INSERT INTO MMWebHook (mm_hook_id, mm_channel_id, user_id) " +
            "VALUES (:#{#mmWebHook.mmHookId}, :#{#mmWebHook.mmChannelId}, :#{#mmWebHook.userId} )")
    Mono<MMWebHook> saveForce(MMWebHook mmWebHook);

    @Query("SELECT EXISTS(SELECT * FROM MMWebHook WHERE mm_channel_id = :mmChannelId)")
    Mono<Boolean> findByMmChannelId(String mmChannelId);

}
