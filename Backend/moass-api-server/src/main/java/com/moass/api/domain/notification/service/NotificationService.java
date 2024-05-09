package com.moass.api.domain.notification.service;

import com.moass.api.domain.notification.dto.NotificationPageDto;
import com.moass.api.domain.notification.dto.NotificationSaveDto;
import com.moass.api.domain.notification.dto.NotificationSendDto;
import com.moass.api.domain.notification.entity.Notification;
import com.moass.api.domain.notification.repository.NotificationRepository;
import com.moass.api.global.auth.dto.UserInfo;
import lombok.NoArgsConstructor;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@Slf4j
@Service
@RequiredArgsConstructor
public class NotificationService {

    private final NotificationRepository notificationRepository;


    public Mono<NotificationPageDto> getAllNotifications(UserInfo userInfo, int page) {
        String userId = userInfo.getUserId();
        PageRequest pageable = PageRequest.of(page-1, 20);

        return notificationRepository.countByUserId(userId)
                .flatMap(totalCount -> {
                    int totalPage = (int) Math.ceil((double) totalCount / 20);
                    return notificationRepository.findByUserIdOrderByCreatedAtDesc(userId, pageable)
                            .collectList()
                            .map(notifications -> new NotificationPageDto(notifications, 1, totalPage));
                });
    }

    // 알림 저장 기능
    public Mono<Notification> saveNotification(NotificationSaveDto notificationSaveDto) {
        log.info("notification  save: {}", notificationSaveDto);
        return notificationRepository.save(new Notification((notificationSaveDto)))
                .map(savedNotification -> {
                    log.info("notification saved: {}", savedNotification);
                    return savedNotification;
                });
    }

    // 여러명에게 알림보내기(유저 리스트로)
    public Mono<Void> sendNotification(NotificationSendDto notificationSendDto) {
        notificationSendDto.getUserIds().forEach(userId -> {
            notificationRepository.save(new Notification(userId, notificationSendDto))
                    .subscribe(savedNotification -> {
                        log.info("notification saved: {}", savedNotification);
                    });
        });
        return Mono.empty();
    }
}
