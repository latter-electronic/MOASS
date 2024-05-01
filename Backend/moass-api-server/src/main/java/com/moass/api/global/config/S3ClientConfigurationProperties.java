package com.moass.api.global.config;

import lombok.Getter;
import lombok.Setter;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;
import software.amazon.awssdk.regions.Region;

import java.net.URI;

@Getter
@Setter
@Component
@ConfigurationProperties(prefix = "aws.s3")
public class S3ClientConfigurationProperties {

    private Region region;
    private String accessKeyId;
    private String secretAccessKey;
//    private URI endpoint;
    private String bucket;

}
