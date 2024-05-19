package com.moass.api.domain.notification.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class NotificationSendDto extends NotificationBase{

    private String notificationId;
    public NotificationSendDto(String source, String title, String body){
        super(source, title, body);
    }


    public NotificationSendDto(MmParseDto mmParseDto){
        super(mmParseDto.getTitle(),mmParseDto.getSource(), mmParseDto.getBody(),mmParseDto.getSender(),mmParseDto.getIcon());
    }

    public NotificationSendDto(String title, String source, String body, String sender, String icon){
        super(title, source, body, sender, icon);
    }

}
