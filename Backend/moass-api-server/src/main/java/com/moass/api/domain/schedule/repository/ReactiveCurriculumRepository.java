package com.moass.api.domain.schedule.repository;

import com.moass.api.domain.schedule.entity.Curriculum;
import org.springframework.data.mongodb.repository.ReactiveMongoRepository;
import reactor.core.publisher.Mono;

public interface ReactiveCurriculumRepository extends ReactiveMongoRepository<Curriculum, String> {
    Mono<Curriculum> findByDate(String date);
}
