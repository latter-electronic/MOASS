package com.moass.api.global.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import software.amazon.awssdk.auth.credentials.AwsBasicCredentials;
import software.amazon.awssdk.auth.credentials.AwsCredentialsProvider;
import software.amazon.awssdk.auth.credentials.DefaultCredentialsProvider;
import software.amazon.awssdk.http.async.SdkAsyncHttpClient;
import software.amazon.awssdk.http.nio.netty.NettyNioAsyncHttpClient;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3AsyncClient;
import software.amazon.awssdk.services.s3.S3AsyncClientBuilder;
import software.amazon.awssdk.services.s3.S3Configuration;
import software.amazon.awssdk.utils.StringUtils;

import java.time.Duration;

@Configuration
public class S3ClientConfiguration {

    @Bean
    public S3AsyncClient s3client(S3ClientConfigurarionProperties s3props, AwsCredentialsProvider credentialsProvider) {
        SdkAsyncHttpClient httpClient = NettyNioAsyncHttpClient.builder()
                .writeTimeout(Duration.ZERO)
                .maxConcurrency(64)
                .build();

        S3Configuration serviceConfiguration = S3Configuration.builder()
                .checksumValidationEnabled(false)
                .chunkedEncodingEnabled(true)
                .build();

        S3AsyncClientBuilder b = S3AsyncClient.builder().httpClient(httpClient)
                .region(Region.of(s3props.getRegion()))
                .credentialsProvider(credentialsProvider)
                .serviceConfiguration(serviceConfiguration);

        return b.build();
    }

    @Bean
    public AwsCredentialsProvider awsCredentialsProvider(S3ClientConfigurarionProperties s3props) {
        if (StringUtils.isBlank(s3props.getAccessKeyId())) {
            return DefaultCredentialsProvider.create();
        } else {
            return () -> {
                return AwsBasicCredentials.create(
                        s3props.getAccessKeyId(),
                        s3props.getSecretAccessKey());
            };
        }
    }
}