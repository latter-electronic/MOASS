package com.moass.api.domain.oauth2.controller;


import com.moass.api.domain.oauth2.dto.MmLoginDto;
import com.moass.api.domain.oauth2.service.MattermostService;
import com.moass.api.global.annotaion.Login;
import com.moass.api.global.auth.dto.UserInfo;
import com.moass.api.global.exception.CustomException;
import com.moass.api.global.response.ApiResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Mono;

@Slf4j
@RestController
@RequestMapping("/oauth2/mm")
@RequiredArgsConstructor
public class MattermostController {

    private final MattermostService mattermostService;
    @PostMapping("/connect")
    public Mono<ResponseEntity<ApiResponse>> mmConnect(@Login UserInfo userInfo, @RequestBody MmLoginDto mmLoginDto){
        return mattermostService.mmConnect(userInfo,mmLoginDto)
                .flatMap(mmToken -> ApiResponse.ok("MM 로그인 성공", mmToken))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("예약 실패 : " + e.getMessage(), e.getStatus()));
    }

    @DeleteMapping("/connect")
    public Mono<ResponseEntity<ApiResponse>> disconnectMattermost(@Login UserInfo userInfo) {
        return mattermostService.disconnectMattermost(userInfo.getUserId())
                .then(ApiResponse.ok("Mattermost 연결 정보가 삭제되었습니다."))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("예약 실패 : " + e.getMessage(), e.getStatus()));
    }

    @GetMapping("/channels")
    public Mono<ResponseEntity<ApiResponse>> getMyChannels(@Login UserInfo userInfo) {
        return mattermostService.getMyChannels(userInfo.getUserId())
                .flatMap(channels -> ApiResponse.ok("채널 정보 조회 성공", channels))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("채널 조회 실패 : " + e.getMessage(), e.getStatus()));
    }

    @PostMapping("/channel/{channelId}")
    public Mono<ResponseEntity<ApiResponse>> toggleChannelSubscription(@Login UserInfo userInfo, @PathVariable String channelId) {
        return mattermostService.toggleChannelSubscription(userInfo.getUserId(), channelId)
                .flatMap(result -> ApiResponse.ok(result ? "구독 추가됨" : "구독 취소됨"))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("구독 토글 실패 : " + e.getMessage(), e.getStatus()));
    }

    @PostMapping("/channel/webhookadd/{teamId}/{channelId}")
    public Mono<ResponseEntity<ApiResponse>> addWebhook(@Login UserInfo userInfo, @PathVariable String teamId, @PathVariable String channelId) {
        return mattermostService.addWebhook(userInfo.getUserId(), teamId, channelId)
                .flatMap(result -> ApiResponse.ok(result ? "웹훅 추가됨" : "웹훅 추가 실패"))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("웹훅 추가 실패 : " + e.getMessage(), e.getStatus()));
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/channel/webhookadd/all")
    public Mono<ResponseEntity<ApiResponse>> addWebhookAll(@Login UserInfo userInfo) {
        return mattermostService.addWebhookAll()
                .flatMap(result -> ApiResponse.ok(result ? "웹훅 추가됨" : "웹훅 추가 실패"))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("웹훅 추가 실패 : " + e.getMessage(), e.getStatus()));
    }

    @GetMapping("/isconnected")
    public Mono<ResponseEntity<ApiResponse>> isConnected(@Login UserInfo userInfo){
        return mattermostService.isConnected(userInfo.getUserId())
                .flatMap(isConnected -> ApiResponse.ok("Gitlab 연결 상태 조회 성공", isConnected))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("Gitlab 연결 상태 조회 실패 : " + e.getMessage(), e.getStatus()));
    }


}
