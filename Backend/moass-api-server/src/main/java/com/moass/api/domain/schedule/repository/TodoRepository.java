package com.moass.api.domain.schedule.repository;

import com.moass.api.domain.schedule.entity.Todo;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.repository.ReactiveMongoRepository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

public interface TodoRepository extends ReactiveMongoRepository<Todo, String> {

    Flux<Todo> findAllByUserId(String userId, Sort sort);

    Mono<Todo> findByTodoIdAndUserId(String todoId, String userId);
}
