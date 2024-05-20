package com.moass.api.domain.oauth2.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.moass.api.domain.oauth2.dto.GitlabConnectInfoDto;
import com.moass.api.domain.oauth2.dto.GitlabIssuesAndMergeRequestsDto;
import com.moass.api.domain.oauth2.dto.TokenResponseDto;
import com.moass.api.domain.oauth2.entity.GitlabProject;
import com.moass.api.domain.oauth2.entity.GitlabToken;
import com.moass.api.domain.oauth2.repository.GitlabProjectRepository;
import com.moass.api.domain.oauth2.repository.GitlabTokenRepository;
import com.moass.api.global.auth.dto.UserInfo;
import com.moass.api.global.config.PropertiesConfig;
import com.moass.api.global.exception.CustomException;
import io.netty.channel.ChannelOption;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.client.reactive.ReactorClientHttpConnector;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.reactive.function.client.ExchangeStrategies;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;
import reactor.netty.http.client.HttpClient;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Slf4j
@Service
public class Oauth2GitlabService {

    private final WebClient gitlabAuthWebClient;

    private final WebClient gitlabApiWebClient;
    private final GitlabTokenRepository gitlabTokenRepository;
    private final PropertiesConfig propertiesConfig;

    private final GitlabProjectRepository gitlabProjectRepository;


    public Oauth2GitlabService(WebClient gitlabAuthWebClient, WebClient gitlabApiWebClient,
                               GitlabTokenRepository gitlabTokenRepository, GitlabProjectRepository gitlabProjectRepository,
                               PropertiesConfig propertiesConfig) {
        this.gitlabAuthWebClient = gitlabAuthWebClient;
        this.gitlabApiWebClient = gitlabApiWebClient;
        this.gitlabTokenRepository = gitlabTokenRepository;
        this.gitlabProjectRepository = gitlabProjectRepository;
        this.propertiesConfig = propertiesConfig;
    }


    public Mono<String> getGitlabConnectUrl(UserInfo userInfo) {
        return Mono.just("https://lab.ssafy.com/oauth" +
                "/authorize?client_id=" + propertiesConfig.getGitlabClientId() +
                "&redirect_uri=" + propertiesConfig.getGitlabRedirectUri() +
                "&scope=api%20read_api%20read_user%20profile%20email" +
                "&response_type=code" +
                "&state=" + userInfo.getUserId());
    }

    public Mono<GitlabToken> exchangeCodeForToken(String code, String state) {
        return exchangeToken(code)
                .flatMap(response -> fetchGitlabUserInfo(response.getAccessToken(), state)
                        .flatMap(userInfo -> saveGitlabToken(response, userInfo, state)));
    }

    private Mono<TokenResponseDto> exchangeToken(String code) {
        return gitlabAuthWebClient.post()
                .uri("/oauth/token")
                .bodyValue(prepareTokenRequest(code))
                .retrieve()
                .bodyToMono(TokenResponseDto.class)
                .doOnSuccess(token -> log.info("Token exchanged successfully"))
                .doOnError(error -> log.error("Error exchanging token: {}", error.getMessage()));
    }

    private Mono<JsonNode> fetchGitlabUserInfo(String accessToken, String userId) {
        return gitlabApiWebClient.get()
                .uri("/api/v4/user")
                .header("Authorization", "Bearer " + accessToken)
                .retrieve()
                .bodyToMono(JsonNode.class)
                .doOnError(error -> log.error("에러 발생", error.getMessage()));
    }

    private Mono<GitlabToken> saveGitlabToken(TokenResponseDto response, JsonNode userInfo, String userId) {
        return gitlabTokenRepository.findByUserId(userId)
                .flatMap(existingToken -> {
                    existingToken.setAccessToken(response.getAccessToken());
                    existingToken.setRefreshToken(response.getRefreshToken());
                    existingToken.setExpiresAt(LocalDateTime.now().plusHours(2));
                    String email = userInfo.path("email").asText();
                    existingToken.setGitlabEmail(email);
                    return gitlabTokenRepository.save(existingToken);
                })
                .switchIfEmpty(Mono.defer(() -> {
                    GitlabToken newToken = new GitlabToken();
                    newToken.setUserId(userId);
                    newToken.setAccessToken(response.getAccessToken());
                    newToken.setRefreshToken(response.getRefreshToken());
                    newToken.setExpiresAt(LocalDateTime.now().plusHours(2));
                    String email = userInfo.path("email").asText();
                    newToken.setGitlabEmail(email);
                    return gitlabTokenRepository.save(newToken);
                }))
                .doOnSuccess(token -> log.info("깃랩토큰 저장성공", userId))
                .doOnError(error -> log.error("저장중 에러발생", error.getMessage()));
    }

    private Map<String, Object> prepareTokenRequest(String code) {
        Map<String, Object> formData = new HashMap<>();
        formData.put("client_id", propertiesConfig.getGitlabClientId());
        formData.put("client_secret", propertiesConfig.getGitlabClientSecret());
        formData.put("code", code);
        formData.put("grant_type", "authorization_code");
        formData.put("redirect_uri", propertiesConfig.getGitlabRedirectUri());
        return formData;
    }

    public Mono<String> getValidAccessToken(String userId) {
        return gitlabTokenRepository.findByUserId(userId)
                .flatMap(token -> {
                    if (token.getExpiresAt().isBefore(LocalDateTime.now())) {
                        log.info("깃랩토큰 시간초과로 리프레쉬됨");
                        return refreshAccessToken(token);
                    } else {
                        return Mono.just(token.getAccessToken());
                    }
                })
                .switchIfEmpty(Mono.error(new CustomException("연결된 깃랩계정이 없습니다.", HttpStatus.FORBIDDEN)));
    }

    private Mono<String> refreshAccessToken(GitlabToken token) {
        return gitlabAuthWebClient.post()
                .uri("/oauth/token")
                .bodyValue(prepareRefreshTokenRequest(token.getRefreshToken()))
                .retrieve()
                .bodyToMono(TokenResponseDto.class)
                .flatMap(response -> {
                    token.setAccessToken(response.getAccessToken());
                    token.setRefreshToken(response.getRefreshToken() != null ? response.getRefreshToken() : token.getRefreshToken());
                    token.setExpiresAt(LocalDateTime.now().plusHours(2));
                    return gitlabTokenRepository.save(token)
                            .map(GitlabToken::getAccessToken);
                });
    }

    private Map<String, Object> prepareRefreshTokenRequest(String refreshToken) {
        Map<String, Object> formData = new HashMap<>();
        formData.put("client_id", propertiesConfig.getGitlabClientId());
        formData.put("client_secret", propertiesConfig.getGitlabClientSecret());
        formData.put("refresh_token", refreshToken);
        formData.put("grant_type", "refresh_token");
        return formData;
    }

    public Mono<GitlabToken> deleteGitlabConnect(UserInfo userInfo) {
        return gitlabTokenRepository.findByUserId(userInfo.getUserId())
                .flatMap(token -> gitlabTokenRepository.delete(token)
                        .then(Mono.just(token)))
                .switchIfEmpty(Mono.error(new CustomException("연동된 Jira 계정이 없습니다.", HttpStatus.FORBIDDEN)));
    }

    public Mono<GitlabProject> saveProjectByName(String userId, String projectName) {
        return getValidAccessToken(userId)
                .flatMap(accessToken -> getProjects(accessToken)
                        .flatMap(projects -> findProjectByName(projects, projectName)
                                .flatMap(project -> saveProject(userId, project))
                        ));
    }

    @Transactional
    public Mono<GitlabProject> deleteProjectByName(String userId, String projectName) {
        return gitlabTokenRepository.findByUserId(userId)
                .switchIfEmpty(Mono.error(new CustomException("연동된 GitLab 계정이 없습니다.", HttpStatus.FORBIDDEN)))
                .flatMap(token -> gitlabProjectRepository.findByGitlabTokenIdAndProjectName(token.getGitlabTokenId(), projectName)
                        .switchIfEmpty(Mono.error(new CustomException("존재하지 않는 프로젝트 이름입니다.", HttpStatus.NOT_FOUND)))
                        .flatMap(project -> gitlabProjectRepository.delete(project)
                                .then(Mono.just(project))
                        )
                );
    }

    private Mono<JsonNode> getProjects(String accessToken) {
        return gitlabApiWebClient.get()
                .uri("/api/v4/projects")
                .header("Authorization", "Bearer " + accessToken)
                .retrieve()
                .bodyToMono(JsonNode.class)
                .timeout(Duration.ofSeconds(10))
                .doOnError(throwable -> log.error("사용자 정보를 가져오는 중 오류 발생", throwable))
                .doOnError(error -> log.error("Error fetching projects: {}", error.getMessage()));
    }

    private Mono<JsonNode> findProjectByName(JsonNode projects, String projectName) {
        for (JsonNode project : projects) {
            if (project.get("name").asText().equals(projectName)) {
                return Mono.just(project);
            }
        }
        return Mono.error(new CustomException("프로젝트를 찾을 수 없습니다.", HttpStatus.NOT_FOUND));
    }

    private Mono<GitlabProject> saveProject(String userId, JsonNode project) {
        String projectId = project.get("id").asText();
        return gitlabTokenRepository.findByUserId(userId)
                .flatMap(gitlabToken -> gitlabProjectRepository.existsByGitlabProjectIdAndGitlabTokenId(projectId,gitlabToken.getGitlabTokenId())
                        .flatMap(exists -> {
                            if (exists) {
                                return Mono.error(new CustomException("이미 등록된 프로젝트입니다.", HttpStatus.CONFLICT));
                            }
                            GitlabProject gitlabProject = GitlabProject.builder()
                                    .gitlabProjectId(projectId)
                                    .gitlabTokenId(gitlabToken.getGitlabTokenId())
                                    .gitlabProjectName(project.get("name").asText())
                                    .build();
                            return gitlabProjectRepository.saveForce(gitlabProject).then(Mono.just(gitlabProject));
                        })
                );
    }

    public Mono<GitlabConnectInfoDto> isConnected(String userId) {
        return gitlabTokenRepository.findByUserId(userId)
                .flatMap(token -> {
                    String email = token.getGitlabEmail();
                    return gitlabProjectRepository.findByGitlabTokenId(token.getGitlabTokenId())
                            .collectList()
                            .map(projects -> {
                                GitlabConnectInfoDto connectInfoDto = new GitlabConnectInfoDto();
                                connectInfoDto.setGitlabEmail(email);
                                List<GitlabConnectInfoDto.GitlabProjectData> projectDataList = projects.stream()
                                        .map(GitlabConnectInfoDto.GitlabProjectData::new)
                                        .collect(Collectors.toList());
                                connectInfoDto.setGitlabProjects(projectDataList);
                                return connectInfoDto;
                            });
                })
                .switchIfEmpty(Mono.error(new CustomException("No GitLab account linked", HttpStatus.FORBIDDEN)));
    }

    public Mono<Map<String, List<GitlabIssuesAndMergeRequestsDto>>> getOpenIssuesAndMergeRequests(String userId) {
        return getValidAccessToken(userId)
                .flatMapMany(accessToken -> gitlabTokenRepository.findByUserId(userId)
                        .flatMapMany(token -> gitlabProjectRepository.findByGitlabTokenId(token.getGitlabTokenId()))
                        .flatMap(project -> fetchProjectIssuesAndMergeRequests(accessToken, project))
                )
                .collect(Collectors.groupingBy(GitlabIssuesAndMergeRequestsDto::getProjectName));
    }

    private Mono<GitlabIssuesAndMergeRequestsDto> fetchProjectIssuesAndMergeRequests(String accessToken, GitlabProject project) {
        return Mono.zip(
                fetchOpenIssues(accessToken, project),
                fetchOpenMergeRequests(accessToken, project),
                (issues, mergeRequests) -> new GitlabIssuesAndMergeRequestsDto(
                        project.getGitlabProjectName(),
                        issues.stream()
                                .sorted(Comparator.comparing(issue -> issue.get("created_at").asText(), Comparator.reverseOrder()))
                                .collect(Collectors.toList()),
                        mergeRequests.stream()
                                .sorted(Comparator.comparing(mergeRequest -> mergeRequest.get("created_at").asText(), Comparator.reverseOrder()))
                                .collect(Collectors.toList())
                )
        );
    }

    private Mono<List<JsonNode>> fetchOpenIssues(String accessToken, GitlabProject project) {
        return gitlabApiWebClient.get()
                .uri(uriBuilder -> uriBuilder.path("/api/v4/projects/{projectId}/issues")
                        .queryParam("state", "opened")
                        .build(project.getGitlabProjectId()))
                .header("Authorization", "Bearer " + accessToken)
                .retrieve()
                .bodyToFlux(JsonNode.class)
                .timeout(Duration.ofSeconds(10))
                .doOnError(throwable -> log.error("이슈 가져오는 중 에러발생 ", throwable))
                .collectList();
    }

    private Mono<List<JsonNode>> fetchOpenMergeRequests(String accessToken, GitlabProject project) {
        return gitlabApiWebClient.get()
                .uri(uriBuilder -> uriBuilder.path("/api/v4/projects/{projectId}/merge_requests")
                        .queryParam("state", "opened")
                        .build(project.getGitlabProjectId()))
                .header("Authorization", "Bearer " + accessToken)
                .retrieve()
                .bodyToFlux(JsonNode.class)
                .timeout(Duration.ofSeconds(10))
                .doOnError(throwable -> log.error("머지리퀘스트 가져오는중 에러발생", throwable))
                .collectList();
    }

}
