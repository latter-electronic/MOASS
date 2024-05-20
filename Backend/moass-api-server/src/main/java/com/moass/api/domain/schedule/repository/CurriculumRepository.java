package com.moass.api.domain.schedule.repository;

import com.moass.api.domain.schedule.entity.Curriculum;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CurriculumRepository extends MongoRepository<Curriculum, String> {
}
