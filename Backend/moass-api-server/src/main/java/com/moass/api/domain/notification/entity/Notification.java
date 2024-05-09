package com.moass.api.domain.notification.entity;

import com.moass.api.domain.notification.dto.NotificationSaveDto;
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

    @Field("source_img")
    private String sourceImg;

    @Field("message")
    private String message;

    @Field("status")
    private Status status;

    @Field("created_at")
    private LocalDateTime createdAt;

    public Notification(NotificationSaveDto notificationSaveDto){
        this.userId = notificationSaveDto.getUserId();
        this.source = notificationSaveDto.getSource();
        this.sourceImg = notificationSaveDto.getSourceImg();
        this.message = notificationSaveDto.getMessage();
        this.status = notificationSaveDto.getStatus();
        this.createdAt = notificationSaveDto.getCreatedAt();
    }

    public Notification(String userId, NotificationSendDto notificationSendDto){
        this.userId = userId;
        this.source = notificationSendDto.getSource();
        this.sourceImg = notificationSendDto.getSourceImg();
        this.message = notificationSendDto.getMessage();
        this.status = notificationSendDto.getStatus();
        this.createdAt = notificationSendDto.getCreatedAt();
    }
}
