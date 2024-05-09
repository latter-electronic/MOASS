package com.moass.api.domain.notification.dto;

import com.moass.api.domain.notification.entity.Notification;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;

@Data
@AllArgsConstructor
public class NotificationPageDto {

    private List<Notification> notifications;

    private Integer page;

    private Integer totalPage;

}
