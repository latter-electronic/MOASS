package com.moass.api.domain.oauth2.dto;


import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class JiraProxyRequestDto {

    private String url;

    private String method;

    private String body;
}
