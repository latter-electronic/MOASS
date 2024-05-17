package com.moass.api.domain.notification.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.moass.api.domain.notification.dto.MmParseDto;
import com.moass.api.domain.notification.dto.NotificationPageDto;
import com.moass.api.domain.notification.dto.NotificationSendDto;
import com.moass.api.domain.notification.entity.Notification;
import com.moass.api.domain.notification.repository.NotificationRepository;
import com.moass.api.domain.oauth2.repository.MmChannelRepository;
import com.moass.api.domain.oauth2.repository.UserMmChannelRepository;
import com.moass.api.domain.user.repository.ClassRepository;
import com.moass.api.domain.user.repository.TeamRepository;
import com.moass.api.global.auth.dto.UserInfo;
import com.moass.api.global.exception.CustomException;
import com.moass.api.global.fcm.dto.FcmNotificationDto;
import com.moass.api.global.fcm.service.FcmService;
import com.moass.api.global.sse.dto.SseNotificationDto;
import com.moass.api.global.sse.dto.SseOrderDto;
import com.moass.api.global.sse.service.SseService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.time.LocalDateTime;

@Slf4j
@Service
@RequiredArgsConstructor
public class NotificationService {

    private final NotificationRepository notificationRepository;
    private final SseService sseService;
    private final FcmService fcmService;
    private final TeamRepository teamRepository;
    private final ClassRepository classRepository;
    private final ObjectMapper objectMapper = new ObjectMapper();
    private final UserMmChannelRepository userMmChannelRepository;
    private final MmChannelRepository mmChannelRepository;
    private final int PageSize = 10;

    public Mono<NotificationPageDto> getAllNotifications(UserInfo userInfo, String lastNotificationId, LocalDateTime lastCreatedAt) {
        String userId = userInfo.getUserId();
        PageRequest pageable = PageRequest.of(0, PageSize);

        return notificationRepository.countByUserIdAndDeletedAtIsNull(userId)
                .flatMap(totalCount -> {
                    Flux<Notification> notificationsFlux = (lastCreatedAt == null) ?
                            notificationRepository.findByUserIdAndDeletedAtIsNullOrderByCreatedAtDesc(userId, pageable) :
                            notificationRepository.findByUserIdAndDeletedAtIsNullAndCreatedAtLessThanOrderByCreatedAtDesc(userId, lastCreatedAt, pageable);
                    return notificationsFlux.collectList()
                            .map(notifications -> {
                                String newLastNotificationId = notifications.isEmpty() ? lastNotificationId : notifications.get(notifications.size() - 1).getNotificationId();
                                LocalDateTime newLastCreatedAt = notifications.isEmpty() ? lastCreatedAt : notifications.get(notifications.size() - 1).getCreatedAt();
                                return new NotificationPageDto(notifications, totalCount, newLastNotificationId, newLastCreatedAt);
                            });
                });
    }


    // 알림 저장 기능
    public Mono<Notification> saveAndPushNotification(String userId, NotificationSendDto notificationSaveDto) {
        log.info("notification  save: {}", notificationSaveDto);
        return notificationRepository.save(new Notification(userId, notificationSaveDto))
                .flatMap(savedNotification -> {
                    Mono<Boolean> sseResult = sseService.notifyUser(userId, new SseNotificationDto(savedNotification));
                    Mono<Integer> fcmResult = fcmService.sendMessageToUser(userId, new FcmNotificationDto(savedNotification));
                    return Mono.zip(sseResult, fcmResult, (sseSuccess, fcmSuccess) -> savedNotification);
                });
    }


    public Mono<Integer> saveAndPushbyTeam(String teamCode, NotificationSendDto notificationSendDto) {
        return teamRepository.findTeamUserByTeamCode(teamCode)
                .switchIfEmpty(Mono.error(new CustomException("해당 팀에 대한 정보가 없습니다.",HttpStatus.NOT_FOUND)))
                .flatMap(user -> saveAndPushNotification(user.getUserId(), notificationSendDto)
                        .thenReturn(1)
                        .onErrorResume(e -> Mono.just(0)))
                .reduce(Integer::sum);
    }

    public Mono<Integer> saveAndPushbyClass(String classCode, NotificationSendDto notificationSendDto) {
        return classRepository.findAllTeamsAndUsersByClassCode(classCode)
                .switchIfEmpty(Mono.error(new CustomException("해당 반에 대한 정보가 없습니다.",HttpStatus.NOT_FOUND)))
                .flatMap(user -> saveAndPushNotification(user.getUserId(), notificationSendDto)
                        .thenReturn(1)
                        .onErrorResume(e -> Mono.just(0)))
                .reduce(Integer::sum);
    }

    public Mono<String> readNotification(UserInfo userInfo, String notificationId) {
        return notificationRepository.findById(notificationId)
                .flatMap(notification -> {
                    if (!notification.getUserId().equals(userInfo.getUserId())) {
                        return Mono.error(new CustomException("내 알림이 아닙니다.", HttpStatus.FORBIDDEN));
                    }
                    notification.setDeletedAt(LocalDateTime.now());
                    return notificationRepository.save(notification)
                            .doOnSuccess(savedNotification -> {
                                sseService.notifyUser(userInfo.getUserId(), new SseOrderDto("readNotification", savedNotification.getNotificationId(),null)).subscribe();
                            })
                            .thenReturn(notification.getNotificationId());
                })
                .switchIfEmpty(Mono.error(new CustomException("알림을 찾을 수 없습니다.", HttpStatus.NOT_FOUND)));
    }

    public Mono<Long> markAllNotificationsAsRead(UserInfo userInfo) {
        String userId = userInfo.getUserId();
        LocalDateTime currentTime = LocalDateTime.now();

        return notificationRepository.findByUserIdAndDeletedAtIsNull(userId)
                .flatMap(notification -> {
                    notification.setDeletedAt(currentTime);
                    return notificationRepository.save(notification);
                })
                .doOnNext(savedNotification -> {
                    sseService.notifyUser(userId, new SseOrderDto("readNotification", savedNotification.getNotificationId(),null)).subscribe();
                })
                .count()
                .onErrorResume(e -> {
                    log.error("알림 읽기 처리 중 오류 발생", e);
                    return Mono.just(0L);
                });
    }

    public Mono<Void> processGitlabEvent(String payload,String teamCode) {
        return Mono.fromCallable(() -> parseGitlabPayload(payload))
                .flatMap(notificationSendDto -> saveAndPushbyTeam(teamCode, notificationSendDto))
                .then();
    }

    private NotificationSendDto parseGitlabPayload(String payload) throws JsonProcessingException {
        JsonNode jsonNode = objectMapper.readTree(payload);
        String source = "gitlab";
        String title = jsonNode.path("object_kind").asText();
        String body = "Event from GitLab: " + jsonNode.path("event_name").asText();
        return new NotificationSendDto(source, title, body);
    }

    @Transactional
    public Mono<Void> processMattermostEvent(String payload) {
        return Mono.fromCallable(() -> parseMattermostPayload(payload))
                .flatMap(mmParseDto -> {
                    String channelId = mmParseDto.getChannelId();
                    return mmChannelRepository.findDetailByChannelId(channelId)
                            .flatMap(mmChannelDetail -> {
                                mmParseDto.setTitle(mmChannelDetail.getMmChannelName());
                                mmParseDto.setIcon(mmChannelDetail.getMmTeamIcon());
                                return userMmChannelRepository.findByMmChannelId(channelId)
                                        .flatMap(userMmChannel -> saveAndPushNotification(userMmChannel.getUserId(), new NotificationSendDto(mmParseDto)))
                                        .then();
                            });
                });
    }

    private MmParseDto parseMattermostPayload(String payload) throws JsonProcessingException {
        JsonNode jsonNode = objectMapper.readTree(payload);
        String source = "mattermost";
        String channelId = jsonNode.path("channel_id").asText();
        String body = jsonNode.path("text").asText();
        String sender = jsonNode.path("user_name").asText();
        log.info(String.valueOf(jsonNode));
        MmParseDto mmParseDto = new MmParseDto(source,body,channelId,sender,"","");
        return mmParseDto;
    }
}