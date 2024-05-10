package com.moass.api.domain.notification.dto;

import com.moass.api.domain.notification.entity.Status;
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

    private Status status = Status.UNREAD;

    private LocalDateTime createdAt = LocalDateTime.now();

    public NotificationBase(String source, String title, String body) {
        this.source = source;
        this.title = title;
        this.body = body;
    }
}