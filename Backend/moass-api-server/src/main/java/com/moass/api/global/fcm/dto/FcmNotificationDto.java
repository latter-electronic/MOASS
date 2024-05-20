package com.moass.api.global.fcm.dto;

import com.moass.api.domain.notification.dto.NotificationBase;
import com.moass.api.domain.notification.entity.Notification;
import lombok.Data;


@Data
public class FcmNotificationDto extends NotificationBase {

    private String notificationId;


    public FcmNotificationDto(Notification notification){
        this.notificationId = notification.getNotificationId();
        this.setSource(notification.getSource());
        this.setIcon(notification.getIcon());
        this.setTitle(notification.getTitle());
        this.setBody(notification.getBody());
        this.setSender(notification.getSender());
        this.setRedirectUrl(notification.getRedirectUrl());
        this.setDeletedAt(notification.getDeletedAt());
        this.setCreatedAt(notification.getCreatedAt());
    }
}
