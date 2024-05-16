package com.moass.api.domain.oauth2.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class MMChannelInfoDto {
    private String mmChannelId;

    private String channelName;

    private String mmTeamId;

    private Boolean isSubscribed;

}
