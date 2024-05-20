package com.moass.api.domain.oauth2.repository;

import com.moass.api.domain.oauth2.entity.GitlabProject;
import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

public interface GitlabProjectRepository extends ReactiveCrudRepository<GitlabProject, String> {

    Flux<GitlabProject> findByGitlabTokenId(Integer gitlabTokenId);

    @Query("INSERT INTO GitlabProject (gitlab_project_id, gitlab_token_id, gitlab_project_name) " +
            "VALUES (:#{#gitlabProject.gitlabProjectId}, :#{#gitlabProject.gitlabTokenId}, :#{#gitlabProject.gitlabProjectName})")
    Mono<Void> saveForce(GitlabProject gitlabProject);

    @Query("SELECT EXISTS(SELECT 1 FROM GitlabProject WHERE gitlab_project_id = :projectId)")
    Mono<Boolean> existsByGitlabProjectId(String projectId);

    @Query("SELECT * FROM GitlabProject WHERE gitlab_token_id = :gitlabTokenId AND gitlab_project_name = :projectName")
    Mono<GitlabProject> findByGitlabTokenIdAndProjectName(Integer gitlabTokenId, String projectName);

    @Query("SELECT EXISTS(SELECT 1 FROM GitlabProject WHERE gitlab_project_id = :projectId AND gitlab_token_id = :gitlabTokenId)")
    Mono<Boolean> existsByGitlabProjectIdAndGitlabTokenId(String projectId, Integer gitlabTokenId);
}
