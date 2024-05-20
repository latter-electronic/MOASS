package com.moass.api.domain.user.dto;

import lombok.Data;

import java.util.List;

@Data
public class LocationInfoDto {
    private String locationCode;
    private String locationName;
    private List<ClassInfoDto> classes;
}
