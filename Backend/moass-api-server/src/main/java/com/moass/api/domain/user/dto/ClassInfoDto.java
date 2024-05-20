package com.moass.api.domain.user.dto;

import lombok.Data;

import java.util.List;

@Data
public class ClassInfoDto {

    private String classCode;
    private String locationCode;
    private List<TeamInfoDto> teams;
}
