package com.moass.api.domain.device.dto;

import com.moass.api.domain.user.dto.UserSearchInfoDto;

import java.util.List;

public class TeamDeviceInfoDto {

    private String teamCode;
    private String teamName;
    private List<UserSearchInfoDto> users;
}
