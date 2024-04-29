package com.moass.api.domain.user.repository;

import com.moass.api.domain.user.entity.Team;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import reactor.core.publisher.Flux;

public interface TeamRepository  extends ReactiveCrudRepository<Team, Integer> {
    Flux<Team> findAllTeamByclassCode(String classCode);
}
