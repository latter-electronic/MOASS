package com.moass.api.domain.webhook.repository;

import com.moass.api.domain.webhook.entity.GitlabHook;
import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import reactor.core.publisher.Mono;

public interface GitlabRepository extends ReactiveCrudRepository<GitlabHook, Integer> {

    Mono<GitlabHook> findByTeamCode(String teamCode);

    @Query("INSERT INTO `GitlabToken` (gitlab_token_id, team_code) " +
            "VALUES (:#{#gitlabToken.gitlabTokenId}, :#{#gitlabToken.teamCode})")
    Mono<GitlabHook> saveForce(GitlabHook gitlabHook);

    @Query("SELECT * FROM `GitlabToken` WHERE gitlab_token_id = :gitlabTokenId")
    Mono<GitlabHook> findByGitlabTokenId(String gitlabTokenId);
}
