package com.moass.api.domain.notification.dto;

import com.moass.api.domain.notification.entity.Status;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
@AllArgsConstructor
public class NotificationSendDto {

    private List<String> userIds;

    private String source;

    private String sourceImg = null;

    private String message;

    private Status status = Status.UNREAD;

    private LocalDateTime createdAt = LocalDateTime.now();

    public NotificationSendDto(List<String> userIds, String source, String message) {
        this.userIds = userIds;
        this.source = source;
        this.message = message;
    }
}
