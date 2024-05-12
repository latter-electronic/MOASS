package com.moass.api.domain.notification.entity;

import com.moass.api.domain.notification.dto.NotificationSendDto;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

import java.time.LocalDateTime;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Document(collection = "Notification")
public class Notification {

    @Id
    private String notificationId;

    @Field("user_id")
    private String userId;

    @Field("source")
    private String source;

    @Field("icon")
    private String icon;

    @Field("title")
    private String title;

    @Field("body")
    private String body;

    @Field("sender")
    private String sender;

    @Field("redirect_url")
    private String redirectUrl;

    @Field("deleted_at")
    private LocalDateTime deletedAt;

    @Field("created_at")
    private LocalDateTime createdAt;

    public Notification(String userId,NotificationSendDto notificationSaveDto){
        this.userId = userId;
        this.source = notificationSaveDto.getSource();
        this.icon = notificationSaveDto.getIcon();
        this.title = notificationSaveDto.getTitle();
        this.body = notificationSaveDto.getBody();
        this.sender = notificationSaveDto.getSender();
        this.redirectUrl = notificationSaveDto.getRedirectUrl();
        this.deletedAt = notificationSaveDto.getDeletedAt();
        this.createdAt = notificationSaveDto.getCreatedAt();

    }

}
