package com.moass.api.domain.notification.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class MmParseDto {
    private String source;
    private String body;
    private String channelId;
    private String sender;
    private String title;
    private String icon;

}
