package com.moass.api.domain.schedule.repository;

import com.moass.api.domain.schedule.entity.Curriculum;
import com.moass.api.domain.schedule.entity.Todo;
import org.springframework.data.mongodb.repository.ReactiveMongoRepository;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Mono;

@Repository
public interface CurriculumRepository extends ReactiveMongoRepository<Curriculum, String> {
    Mono<Todo> findByDate(String date);
}
