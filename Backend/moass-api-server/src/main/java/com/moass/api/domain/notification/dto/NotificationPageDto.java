package com.moass.api.domain.notification.dto;

import com.moass.api.domain.notification.entity.Notification;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
@AllArgsConstructor
public class NotificationPageDto {

    private List<Notification> notifications;

    private Long totalCount;

    private String lastNotificationId;

    private LocalDateTime lastCreatedAt;

}
