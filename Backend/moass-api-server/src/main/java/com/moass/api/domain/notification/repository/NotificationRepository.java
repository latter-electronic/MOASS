package com.moass.api.domain.notification.repository;

import com.moass.api.domain.notification.entity.Notification;
import org.springframework.data.domain.Pageable;
import org.springframework.data.mongodb.repository.ReactiveMongoRepository;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;


@Repository
public interface NotificationRepository extends ReactiveMongoRepository<Notification, String> {
    Mono<Long> countByUserId(String userId);

    Flux<Notification> findByUserIdOrderByCreatedAtDesc(String userId, Pageable pageable);
}