package com.moass.api.domain.oauth2.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.moass.api.domain.oauth2.dto.MMChannelInfoDto;
import com.moass.api.domain.oauth2.dto.MmChannelSearchDto;
import com.moass.api.domain.oauth2.dto.MmLoginDto;
import com.moass.api.domain.oauth2.entity.MMChannel;
import com.moass.api.domain.oauth2.entity.MMTeam;
import com.moass.api.domain.oauth2.entity.MMToken;
import com.moass.api.domain.oauth2.entity.UserMMChannel;
import com.moass.api.domain.oauth2.repository.MmChannelRepository;
import com.moass.api.domain.oauth2.repository.MmTeamRepository;
import com.moass.api.domain.oauth2.repository.MmTokenRepository;
import com.moass.api.domain.oauth2.repository.UserMmChannelRepository;
import com.moass.api.global.auth.dto.UserInfo;
import com.moass.api.global.config.PropertiesConfig;
import com.moass.api.global.config.S3ClientConfigurationProperties;
import com.moass.api.global.exception.CustomException;
import com.moass.api.global.service.S3Service;
import io.netty.channel.ChannelOption;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.client.reactive.ReactorClientHttpConnector;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.reactive.function.client.ClientResponse;
import org.springframework.web.reactive.function.client.ExchangeStrategies;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.util.UriComponentsBuilder;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import reactor.netty.http.client.HttpClient;

import java.nio.ByteBuffer;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Slf4j
@Service
public class MattermostService {

    private final WebClient mmApiWebClient;
    private final PropertiesConfig propertiesConfig;

    private final UserMmChannelRepository userMmChannelRepository;
    private final MmTokenRepository mmTokenRepository;
    private final MmChannelRepository mmChannelRepository;
    private final MmTeamRepository mmTeamRepository;

    private final S3ClientConfigurationProperties s3config;
    private final S3Service s3Service;

    public MattermostService(WebClient mmApiWebClient, PropertiesConfig propertiesConfig, UserMmChannelRepository userMMChannelRepository, MmTokenRepository mmTokenRepository, MmChannelRepository mmChannelRepository, MmTeamRepository mmTeamRepository, S3ClientConfigurationProperties s3config, S3Service s3Service) {
        this.mmApiWebClient = mmApiWebClient;
        this.propertiesConfig = propertiesConfig;
        this.userMmChannelRepository = userMMChannelRepository;
        this.mmTokenRepository = mmTokenRepository;
        this.mmChannelRepository = mmChannelRepository;
        this.mmTeamRepository = mmTeamRepository;
        this.s3config = s3config;
        this.s3Service = s3Service;
    }


    @Transactional
    public Mono<MMToken> mmConnect(UserInfo userInfo, MmLoginDto mmLoginDto) {
        return mmApiWebClient.post()
                .uri("/api/v4/users/login")
                .bodyValue(prepareLoginRequest(mmLoginDto))
                .exchangeToMono(response -> {
                    if (response.statusCode().is2xxSuccessful()) {
                        return saveOrUpdateToken(response, userInfo.getUserId());
                    } else {
                        return response.bodyToMono(String.class)
                                .flatMap(body -> Mono.error(new CustomException("로그인 실패: " + body, HttpStatus.FORBIDDEN)));
                    }
                })
                .doOnError(error -> log.error("로그인 에러: {}", error.getMessage()))
                .flatMap(token -> Mono.just(token));
    }

    private Mono<MMToken> saveOrUpdateToken(ClientResponse response, String userId) {
        String token = response.headers().header("Token").get(0);
        return mmTokenRepository.findByUserId(userId)
                .flatMap(existingToken -> {
                    existingToken.setSessionToken(token);
                    return mmTokenRepository.save(existingToken);
                })
                .switchIfEmpty(Mono.defer(() -> {
                    MMToken newToken = new MMToken();
                    newToken.setUserId(userId);
                    newToken.setSessionToken(token);
                    newToken.setUpdatedAt(LocalDateTime.now());
                    newToken.setCreatedAt(LocalDateTime.now());
                    return mmTokenRepository.save(newToken);
                }))
                .doOnSuccess(t -> log.info("Mattermost 토큰 저장 성공"))
                .doOnError(e -> log.error("Mattermost 토큰 저장 실패", e));
    }

    private Map<String, String> prepareLoginRequest(MmLoginDto mmLoginDto) {
        Map<String, String> formData = new HashMap<>();
        formData.put("login_id", mmLoginDto.getLoginId());
        formData.put("password", mmLoginDto.getPassword());
        return formData;
    }

    @Transactional
    public Mono<List<MmChannelSearchDto>> getMyChannels(String userId) {
        return mmTokenRepository.findByUserId(userId)
                .flatMap(token -> mmApiWebClient.get()
                        .uri("/api/v4/users/me/teams")
                        .header("Authorization", "Bearer " + token.getSessionToken())
                        .retrieve()
                        .bodyToFlux(JsonNode.class)
                        .collectList()
                        .flatMapMany(Flux::fromIterable)
                        .flatMap(team -> saveOrUpdateTeam(team, token.getSessionToken()))
                        .flatMap(savedTeam -> getChannelsForTeam(savedTeam, token.getSessionToken(), userId))
                        .collectList()
                        .map(teamList -> teamList.stream()
                                .sorted((a, b) -> a.getMmTeamName().compareToIgnoreCase(b.getMmTeamName()))
                                .collect(Collectors.toList()))
                )
                .defaultIfEmpty(Collections.emptyList())
                .onErrorResume(e -> Mono.just(Collections.emptyList()));
    }

    private Mono<MMTeam> saveOrUpdateTeam(JsonNode team, String token) {
        String teamId = team.get("id").asText();
        String teamName = team.get("display_name").asText();
        return mmTeamRepository.findById(teamId)
                .flatMap(existingTeam -> {
                    if (!existingTeam.getMmTeamName().equals(teamName)) {
                        existingTeam.setMmTeamName(teamName);
                        return getTeamIcon(token, teamId)
                                .flatMap(icon -> {
                                    existingTeam.setMmTeamIcon(icon);
                                    return mmTeamRepository.save(existingTeam)
                                            .then(Mono.just(existingTeam));
                                });
                    }
                    return Mono.just(existingTeam);
                })
                .switchIfEmpty(Mono.defer(() -> getTeamIcon(token, teamId)
                        .flatMap(icon -> {
                            MMTeam newTeam = new MMTeam(teamId, teamName, icon);
                            return mmTeamRepository.saveForce(newTeam)
                                    .then(Mono.just(newTeam));
                        })));
    }

    private Mono<String> getTeamIcon(String token, String teamId) {
        return mmApiWebClient.get()
                .uri("/api/v4/teams/" + teamId + "/image")
                .header("Authorization", "Bearer " + token)
                .retrieve()
                .bodyToMono(byte[].class)
                .flatMap(imageData -> {
                    String key = "team-icons/" + teamId + ".png";
                    HttpHeaders headers = new HttpHeaders();
                    headers.setContentLength(imageData.length);
                    headers.setContentType(MediaType.IMAGE_PNG);
                    Flux<ByteBuffer> body = Flux.just(ByteBuffer.wrap(imageData));
                    return s3Service.uploadHandler(headers, body)
                            .flatMap(uploadResult -> {
                                if (uploadResult.getStatus() != HttpStatus.CREATED) {
                                    return Mono.error(new CustomException("Image upload failed", HttpStatus.INTERNAL_SERVER_ERROR));
                                }
                                return Mono.just(s3config.getImageUrl() + "/" + uploadResult.getKeys()[0]);
                            });
                })
                .onErrorResume(error -> {
                    log.error("팀 아이콘을 가져오는 중 오류 발생: {}", error.getMessage());
                    return Mono.just("");
                });
    }

    private Mono<MmChannelSearchDto> getChannelsForTeam(MMTeam team, String token, String userId) {
        log.info("채널 조회: {}", team.getMmTeamName());
        return mmApiWebClient.get()
                .uri("/api/v4/teams/" + team.getMmTeamId() + "/channels")
                .header("Authorization", "Bearer " + token)
                .retrieve()
                .bodyToFlux(JsonNode.class)
                .filter(channel -> "O".equals(channel.get("type").asText()))
                .flatMap(channel -> saveOrUpdateChannel(team.getMmTeamId(), channel, userId))
                .collectList()
                .map(channelList -> channelList.stream()
                        .sorted((a, b) -> a.getChannelName().compareToIgnoreCase(b.getChannelName()))
                        .collect(Collectors.toList()))
                .flatMap(channels -> {
                    MmChannelSearchDto dto = new MmChannelSearchDto();
                    dto.setMmTeamName(team.getMmTeamName());
                    dto.setMmTeamId(team.getMmTeamId());
                    dto.setMmTeamIcon(team.getMmTeamIcon());
                    dto.setMmChannelList(channels);
                    return Mono.just(dto);
                });
    }

    private Mono<MMChannelInfoDto> saveOrUpdateChannel(String teamId, JsonNode channel, String userId) {
        String channelId = channel.get("id").asText();
        String channelName = channel.get("display_name").asText();
        return mmChannelRepository.findById(channelId)
                .flatMap(existingChannel -> {
                    if (!existingChannel.getMmChannelName().equals(channelName)) {
                        existingChannel.setMmChannelName(channelName);
                        return mmChannelRepository.save(existingChannel)
                                .flatMap(savedChannel -> userMmChannelRepository.existsByUserIdAndMmChannelId(userId, savedChannel.getMmChannelId())
                                        .map(exists -> new MMChannelInfoDto(savedChannel.getMmChannelId(), savedChannel.getMmChannelName(), savedChannel.getMmTeamId(), exists)));
                    }
                    return userMmChannelRepository.existsByUserIdAndMmChannelId(userId, existingChannel.getMmChannelId())
                            .map(exists -> new MMChannelInfoDto(existingChannel.getMmChannelId(), existingChannel.getMmChannelName(), existingChannel.getMmTeamId(), exists));
                })
                .switchIfEmpty(Mono.defer(() -> {
                    MMChannel newChannel = new MMChannel(channelId, channelName, teamId);
                    return mmChannelRepository.saveForce(newChannel).then(Mono.just(newChannel))
                            .flatMap(savedChannel -> userMmChannelRepository.existsByUserIdAndMmChannelId(userId, savedChannel.getMmChannelId())
                                    .map(exists -> new MMChannelInfoDto(savedChannel.getMmChannelId(), savedChannel.getMmChannelName(), savedChannel.getMmTeamId(), exists)));
                }))
                .map(channelInfoDto -> channelInfoDto);
    }

    @Transactional
    public Mono<Boolean> toggleChannelSubscription(String userId, String channelId) {
        return userMmChannelRepository.existsByUserIdAndMmChannelId(userId, channelId)
                .flatMap(exists -> {
                    if (exists) {
                        return userMmChannelRepository.deleteByUserIdAndMmChannelId(userId, channelId)
                                .thenReturn(false);
                    } else {
                        return mmChannelRepository.findById(channelId)
                                .switchIfEmpty(Mono.error(new CustomException("채널을 찾을 수 없습니다.", HttpStatus.NOT_FOUND)))
                                .flatMap(channel -> mmTokenRepository.findByUserId(userId)
                                        .switchIfEmpty(Mono.error(new CustomException("Mattermost 토큰이 없습니다.", HttpStatus.UNAUTHORIZED)))
                                        .flatMap(token -> createOrUpdateOutgoingWebhook(channel.getMmTeamId(), channelId, token.getSessionToken()))
                                        .then(userMmChannelRepository.save(new UserMMChannel(userId, channelId)))
                                        .thenReturn(true));
                    }
                })
                .switchIfEmpty(Mono.error(new CustomException("채널 구독 상태를 변경할 수 없습니다.", HttpStatus.INTERNAL_SERVER_ERROR)));
    }

    @Transactional
    public Mono<Boolean> addWebhook(String userId, String teamId, String channelId) {
        return mmTokenRepository.findByUserId(userId)
                .flatMap(token -> createOrUpdateOutgoingWebhook(teamId, channelId, token.getSessionToken()))
                .switchIfEmpty(Mono.error(new CustomException("Mattermost 토큰이 없습니다.", HttpStatus.UNAUTHORIZED)));
    }

    @Transactional
    public Mono<Boolean> addWebhookAll() {
        return mmTokenRepository.findAll()
                .flatMap(token -> mmChannelRepository.findAll()
                        .flatMap(channel -> createOrUpdateOutgoingWebhook(channel.getMmTeamId(), channel.getMmChannelId(), token.getSessionToken()))
                        .collectList()
                )
                .then(Mono.just(true))
                .onErrorResume(e -> {
                    log.error("Failed to add webhooks to all channels", e);
                    return Mono.just(false);
                });
    }
    public Mono<Boolean> createOrUpdateOutgoingWebhook(String teamId, String channelId, String token) {
        String callbackUri1 = propertiesConfig.getMmWebhookUri1();
        String callbackUri2 = propertiesConfig.getMmWebhookUri2();
        String[] callbackUris = new String[]{callbackUri1, callbackUri2};
        UriComponentsBuilder builder = UriComponentsBuilder.fromUriString("/api/v4/hooks/outgoing")
                .queryParam("channel_id", channelId);
        log.info("웹훅 연동중 팀 : {} , 채널: {}. uri : {}", teamId, channelId,builder.toUriString());
        return mmApiWebClient.get()
                .uri(builder.toUriString())
                .header("Authorization", "Bearer " + token)
                .retrieve()
                .bodyToFlux(JsonNode.class)
                .collectList()
                .flatMap(webhooks -> {
                    if (!webhooks.isEmpty()) {
                        String webhookId = webhooks.get(0).get("id").asText();
                        return deleteOutgoingWebhook(webhookId, token)
                                .then(createOutgoingWebhook(teamId, channelId, callbackUris, token));
                    } else {
                        return createOutgoingWebhook(teamId, channelId, callbackUris, token);
                    }
                })
                .then(Mono.just(true))
                .onErrorResume(e -> {
                    log.error("웹훅 업데이트중 에러발생", e);
                    return Mono.just(false);
                });
    }

    private Mono<Void> createOutgoingWebhook(String teamId, String channelId, String[] callbackUris, String token) {
        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("team_id", teamId);
        requestBody.put("channel_id", channelId);
        requestBody.put("display_name", "moass_hook");
        requestBody.put("content_type", "application/json");
        requestBody.put("callback_urls", callbackUris);
        requestBody.put("trigger_words", new String[]{});
        requestBody.put("trigger_when", 0);

        return mmApiWebClient.post()
                .uri("/api/v4/hooks/outgoing")
                .header("Authorization", "Bearer " + token)
                .bodyValue(requestBody)
                .retrieve()
                .bodyToMono(Void.class)
                .doOnError(error -> log.error("웹훅 생성중 에러", error,requestBody));
    }

    private Mono<Void> deleteOutgoingWebhook(String webhookId, String token) {
        return mmApiWebClient.delete()
                .uri("/api/v4/hooks/outgoing/" + webhookId)
                .header("Authorization", "Bearer " + token)
                .retrieve()
                .bodyToMono(Void.class)
                .doOnSuccess(v -> log.info("웹훅 삭제 성공",webhookId))
                .doOnError(error -> log.error("웹훅 삭제중 에러", error));
    }

    public Mono<MMToken> isConnected(String userId) {
        return mmTokenRepository.findByUserId(userId)
                .switchIfEmpty(Mono.error(new CustomException("Mattermost 토큰이 없습니다.", HttpStatus.FORBIDDEN)));
    }

    @Transactional
    public Mono<String> disconnectMattermost(String userId) {
        return mmTokenRepository.findByUserId(userId)
                .flatMap(token -> userMmChannelRepository.deleteByUserId(userId)
                        .onErrorResume(e -> Mono.empty())
                        .then(mmTokenRepository.delete(token))
                        .then(Mono.just(token.getUserId())))
                .switchIfEmpty(Mono.defer(() -> Mono.error(new CustomException("Mattermost 연결 정보가 없습니다.", HttpStatus.NOT_FOUND))));
    }

}
