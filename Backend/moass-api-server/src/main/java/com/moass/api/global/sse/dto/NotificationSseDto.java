package com.moass.api.global.sse.dto;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class NotificationSseDto {

    private String command="notification";

    private String id;

    private String source;

    private String sourceImg;

    private String message;

    private LocalDateTime createdAt;

    public NotificationSseDto(String id, String source, String sourceImg, String message, LocalDateTime createdAt) {
        this.id = id;
        this.source = source;
        this.sourceImg = sourceImg;
        this.message = message;
        this.createdAt = createdAt;
    }

}
