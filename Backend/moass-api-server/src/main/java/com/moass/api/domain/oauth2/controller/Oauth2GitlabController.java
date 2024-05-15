package com.moass.api.domain.oauth2.controller;


import com.moass.api.domain.oauth2.service.Oauth2GitlabService;
import com.moass.api.global.annotaion.Login;
import com.moass.api.global.auth.dto.UserInfo;
import com.moass.api.global.exception.CustomException;
import com.moass.api.global.response.ApiResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Mono;

@Slf4j
@RestController
@RequestMapping("/oauth2/gitlab")
@RequiredArgsConstructor
public class Oauth2GitlabController {

    private final Oauth2GitlabService oauth2GitlabService;

    @GetMapping("/connect")
    public Mono<ResponseEntity<ApiResponse>> gitlabConnect(@Login UserInfo userInfo){
        return oauth2GitlabService.getGitlabConnectUrl(userInfo)
                .flatMap(gitlabConnectUrl -> ApiResponse.ok("Gitlab 연동주소 조회 성공", gitlabConnectUrl))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("조회 실패 : " + e.getMessage(), e.getStatus()));
    }

    @DeleteMapping("/connect")
    public Mono<ResponseEntity<ApiResponse>> gitlabDeleteConnect(@Login UserInfo userInfo){
        return oauth2GitlabService.deleteGitlabConnect(userInfo)
                .flatMap(gitlabConnectUrl -> ApiResponse.ok("Gitlab 연동 제 성공", gitlabConnectUrl))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("연동삭제 실패 : " + e.getMessage(), e.getStatus()));
    }
    @GetMapping("/callback")
    public Mono<ResponseEntity<ApiResponse>> gitlabCallback(@RequestParam String code, @RequestParam String state) {
        return oauth2GitlabService.exchangeCodeForToken(code,state)
                .flatMap(token -> ApiResponse.ok("GitLab 토큰 발급 성공", token))
                .onErrorResume(CustomException.class,e ->ApiResponse.error("GitLab 토큰 발급 실패: " + e.getMessage(),e.getStatus()));
    }

    @PostMapping("/refresh")
    public Mono<ResponseEntity<ApiResponse>> refreshToken(@Login UserInfo userInfo) {
        return oauth2GitlabService.getValidAccessToken(userInfo.getUserId())
                .flatMap(token -> ApiResponse.ok("GitLab 토큰 갱신 성공", token))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("GitLab 토큰 갱신 실패 : " + e.getMessage(), e.getStatus()));
    }

    @GetMapping("/isconnected")
    public Mono<ResponseEntity<ApiResponse>> isConnected(@Login UserInfo userInfo){
        return oauth2GitlabService.isConnected(userInfo.getUserId())
                .flatMap(isConnected -> ApiResponse.ok("Gitlab 연결 상태 조회 성공", isConnected))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("Gitlab 연결 상태 조회 실패 : " + e.getMessage(), e.getStatus()));
    }

    @PostMapping("/projects")
    public Mono<ResponseEntity<ApiResponse>> saveProjectByName(@Login UserInfo userInfo, @RequestParam(name="projectname") String projectName) {
        return oauth2GitlabService.saveProjectByName(userInfo.getUserId(), projectName)
                .flatMap(project -> ApiResponse.ok("프로젝트 저장 성공", project))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("Gitlab 프로젝트 저장 실패 : " + e.getMessage(), e.getStatus()));
    }

    @DeleteMapping("/projects")
    public Mono<ResponseEntity<ApiResponse>> deleteProjectByName(@Login UserInfo userInfo, @RequestParam(name="projectname") String projectName) {
        return oauth2GitlabService.deleteProjectByName(userInfo.getUserId(), projectName)
                .flatMap(project -> ApiResponse.ok("프로젝트 삭제 성공", project))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("Gitlab 프로젝트 삭제 실패 : " + e.getMessage(), e.getStatus()));
    }

    @GetMapping("/projectinfos")
    public Mono<ResponseEntity<ApiResponse>> getProjectInfos(@Login UserInfo userInfo) {
        return oauth2GitlabService.getOpenIssuesAndMergeRequests(userInfo.getUserId())
                .flatMap(projectInfos -> ApiResponse.ok("프로젝트 정보 조회 성공", projectInfos))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("Gitlab 프로젝트 정보 조회 실패 : " + e.getMessage(), e.getStatus()));
    }
}
