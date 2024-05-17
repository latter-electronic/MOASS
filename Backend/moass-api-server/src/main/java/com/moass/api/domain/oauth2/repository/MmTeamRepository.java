package com.moass.api.domain.oauth2.repository;

import com.moass.api.domain.oauth2.entity.MMTeam;

import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import reactor.core.publisher.Mono;

public interface MmTeamRepository    extends ReactiveCrudRepository<MMTeam, String> {

    @Query("INSERT INTO MMTeam (mm_team_id, mm_team_name, mm_team_icon) " +
            "VALUES (:#{#mmTeam.mmTeamId}, :#{#mmTeam.mmTeamName}, :#{#mmTeam.mmTeamIcon})")
    Mono<MMTeam> saveForce(MMTeam mmTeam);
}
