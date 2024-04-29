package com.moass.api.domain.user.repository;

import com.moass.api.domain.user.entity.Class;
import com.moass.api.domain.user.entity.Location;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;

public interface ClassRepository extends ReactiveCrudRepository<Class, Integer> {


}
