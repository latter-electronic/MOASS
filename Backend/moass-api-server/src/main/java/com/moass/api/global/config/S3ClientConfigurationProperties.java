package com.moass.api.global.config;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;
import software.amazon.awssdk.regions.Region;

import java.net.URI;

@ConfigurationProperties(prefix = "aws.s3")
@Data
public class S3ClientConfigurationProperties {

    private Region region = Region.AP_NORTHEAST_2;
    private String accessKeyId;
    private String secretAccessKey;
    private URI endpoint = null;
    private String imageUrl;
    private String bucket;

}
