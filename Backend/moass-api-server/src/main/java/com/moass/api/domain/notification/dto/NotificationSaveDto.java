package com.moass.api.domain.notification.dto;

import com.moass.api.domain.notification.entity.Status;
import lombok.AllArgsConstructor;
import lombok.Data;
import org.springframework.data.mongodb.core.mapping.Field;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
public class NotificationSaveDto {

    private String userId;

    private String source;

    private String sourceImg = null;

    private String message;

    private Status status = Status.UNREAD;

    private LocalDateTime createdAt = LocalDateTime.now();

    public NotificationSaveDto(String userId, String source, String message) {
        this.userId = userId;
        this.source = source;
        this.message = message;
    }

    public NotificationSaveDto(String usetId,NotificationFormDto notificationFormDto){
        this.userId = userId;
        this.source = notificationFormDto.getSource();
        this.sourceImg = notificationFormDto.getSourceImg();
        this.message = notificationFormDto.getMessage();
        this.status = notificationFormDto.getStatus();
        this.createdAt = notificationFormDto.getCreatedAt();
    }
}
