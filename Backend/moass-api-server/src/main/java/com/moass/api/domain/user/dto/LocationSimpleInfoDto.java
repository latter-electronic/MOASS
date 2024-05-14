package com.moass.api.domain.user.dto;

import lombok.Data;

import java.util.List;

@Data
public class LocationSimpleInfoDto {

    private String locationName;
    private List<String> classes;


    public LocationSimpleInfoDto(String locationName, List<String> classes) {
        this.locationName = locationName;
        this.classes = classes;
    }
}