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
public class SseNotificationDto {

    private String command = "notification";
    private NotificationData data;

    @Data
    @NoArgsConstructor
    public static class NotificationData extends NotificationBase {
        private String notificationId;

        public NotificationData(Notification notification) {
            this.notificationId = notification.getNotificationId();
            this.setSource(notification.getSource());
            this.setIcon(notification.getIcon());
            this.setTitle(notification.getTitle());
            this.setBody(notification.getBody());
            this.setSender(notification.getSender());
            this.setRedirectUrl(notification.getRedirectUrl());
            this.setDeletedAt(notification.getDeletedAt() != null ? notification.getDeletedAt() : null);
            this.setCreatedAt(notification.getCreatedAt() != null ? notification.getCreatedAt() : null);
        }

        public NotificationData(String source, String title, String body){
            this.setSource(source);
            this.setTitle(title);
            this.setBody(body);
        }
    }

    public SseNotificationDto(Notification notification) {
        this.data = new NotificationData(notification);
    }

    public SseNotificationDto(String source, String title, String body){
        this.data = new NotificationData(source, title, body);
    }
}
