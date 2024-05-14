package com.moass.api.domain.webhook.repository;

import com.moass.api.domain.user.entity.User;
import com.moass.api.domain.webhook.entity.GitlabToken;
import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import reactor.core.publisher.Mono;

public interface GitlabRepository extends ReactiveCrudRepository<GitlabToken, Integer> {

    Mono<GitlabToken> findByTeamCode(String teamCode);

    @Query("INSERT INTO `GitlabToken` (gitlab_token_id, team_code) " +
            "VALUES (:#{#gitlabToken.gitlabTokenId}, :#{#gitlabToken.teamCode})")
    Mono<GitlabToken> saveForce(GitlabToken gitlabToken);
}
