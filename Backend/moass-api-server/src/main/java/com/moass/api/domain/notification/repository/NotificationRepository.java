package com.moass.api.domain.notification.repository;

import com.moass.api.domain.notification.entity.Notification;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.mongodb.repository.ReactiveMongoRepository;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.time.LocalDateTime;


@Repository
public interface NotificationRepository extends ReactiveMongoRepository<Notification, String> {

    Mono<Long> countByUserIdAndDeletedAtIsNull(String userId);

    Flux<Notification> findByUserIdAndDeletedAtIsNullOrderByCreatedAtDesc(String userId, PageRequest pageable);

    Flux<Notification> findByUserIdAndDeletedAtIsNullAndCreatedAtLessThanOrderByCreatedAtDesc(String userId, LocalDateTime lastCreatedAt, PageRequest pageable);

    Flux<Notification> findByUserIdAndDeletedAtIsNull(String userId);
}