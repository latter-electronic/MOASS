package com.moass.api.global.config;

import lombok.Getter;
import lombok.Setter;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Configuration;

@Getter
@Setter
@Configuration
@EnableConfigurationProperties
@ConfigurationProperties(prefix="value")
public class PropertiesConfig {

     private String accessKey;
     private String refreshKey;

     private String jiraClientId;
     private String jiraClientSecret;
     private String jiraRedirectUri;

     private String gitlabClientId;
    private String gitlabClientSecret;
    private String gitlabRedirectUri;

    private String mmBaseUri;
    private String mmRedirectUri;
    private String mmWebhookUri1;
    private String mmWebhookUri2;


}
