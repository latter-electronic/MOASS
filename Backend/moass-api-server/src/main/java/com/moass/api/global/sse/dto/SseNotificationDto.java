package com.moass.api.global.sse.dto;

import com.moass.api.domain.notification.dto.NotificationBase;
import com.moass.api.domain.notification.entity.Notification;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SseNotificationDto extends NotificationBase {

    private String command="notification";

    private String notificationId;

    public SseNotificationDto(Notification notification) {
        this.notificationId = notification.getNotificationId();
        this.setSource(notification.getSource());
        this.setIcon(notification.getIcon());
        this.setTitle(notification.getTitle());
        this.setBody(notification.getBody());
        this.setSender(notification.getSender());
        this.setRedirectUrl(notification.getRedirectUrl());
        this.setStatus(notification.getStatus());
        this.setCreatedAt(notification.getCreatedAt());
    }

    public SseNotificationDto(String source, String title, String body){
        this.setSource(source);
        this.setTitle(title);
        this.setBody(body);
    }

}
