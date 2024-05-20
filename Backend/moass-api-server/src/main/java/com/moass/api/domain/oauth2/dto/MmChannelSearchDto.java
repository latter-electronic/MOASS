package com.moass.api.domain.oauth2.dto;

import lombok.Data;

import java.util.List;

@Data
public class MmChannelSearchDto {
    private String mmTeamName;
    private String mmTeamId;
    private String mmTeamIcon;
    private List<MMChannelInfoDto> mmChannelList;
}
