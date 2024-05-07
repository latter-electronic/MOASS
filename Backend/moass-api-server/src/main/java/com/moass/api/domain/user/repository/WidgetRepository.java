package com.moass.api.domain.user.repository;


import com.moass.api.domain.user.entity.Widget;
import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

public interface WidgetRepository  extends ReactiveCrudRepository<Widget, Integer> {

    @Query("SELECT * FROM Widget WHERE user_id = :userId ORDER BY created_at DESC")
    Flux<Widget> findAllByUserId(String userId);

    @Query("SELECT * FROM Widget WHERE widget_id = :widgetId AND user_id = :userId")
    Mono<Widget> findByWidgetIdAndUserId(String widgetId, String userId);
}
