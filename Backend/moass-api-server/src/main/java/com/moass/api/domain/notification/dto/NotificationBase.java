package com.moass.api.domain.notification.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class NotificationBase {


    private String source;

    private String icon = null;

    private String title;

    private String body;

    private String sender = null;

    private String redirectUrl = null;

    private  LocalDateTime deletedAt = null;

    private LocalDateTime createdAt = LocalDateTime.now();

    public NotificationBase(String source, String title, String body) {
        this.source = source;
        this.title = title;
        this.body = body;
    }

    public NotificationBase(String title, String source, String body, String sender,String icon) {
        this.source = source;
        this.title = title;
        this.body = body;
        this.sender = sender;
        this.icon = icon;
    }
}