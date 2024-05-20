package com.moass.api.domain.seat.repository;

import com.moass.api.domain.user.entity.Class;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;

public interface SeatRepository  extends ReactiveCrudRepository<Class, Integer> {
}
