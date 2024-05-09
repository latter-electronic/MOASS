package com.moass.api.domain.notification.dto;

import com.moass.api.domain.notification.entity.Status;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
public class NotificationFormDto {


    private String source;

    private String sourceImg = null;

    private String message;

    private Status status = Status.UNREAD;

    private LocalDateTime createdAt = LocalDateTime.now();

    public NotificationFormDto(String source, String message) {
        this.source = source;
        this.message = message;
    }
}