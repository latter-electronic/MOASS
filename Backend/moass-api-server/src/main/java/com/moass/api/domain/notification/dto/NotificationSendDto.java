package com.moass.api.domain.notification.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class NotificationSendDto extends NotificationBase{

    private String notificationId;
    public NotificationSendDto(String source, String title, String body){
        super(source, title, body);
    }

    public NotificationSendDto(String title, String source, String body, String sender){
        super(title, source, body, sender);
    }

    public NotificationSendDto(MmParseDto mmParseDto){
        super(mmParseDto.getTitle(),mmParseDto.getSource(), mmParseDto.getBody(),mmParseDto.getSender());
    }
}
