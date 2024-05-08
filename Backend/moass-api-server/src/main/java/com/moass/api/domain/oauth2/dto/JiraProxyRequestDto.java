package com.moass.api.domain.oauth2.dto;


import lombok.Data;

@Data
public class JiraProxyRequestDto {

    private String url;

    private String method;
}
