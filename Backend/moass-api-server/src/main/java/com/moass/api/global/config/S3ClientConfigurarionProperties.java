package com.moass.api.global.config;

import lombok.Getter;
import lombok.Setter;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

@Getter
@Setter
@Component
@ConfigurationProperties(prefix = "aws.s3")
public class S3ClientConfigurarionProperties {

    private String accessKeyId;
    private String secretAccessKey;
    private String region;

}
