package com.moass.api.domain.file.controller;

import com.moass.api.domain.file.dto.UploadResult;
import com.moass.api.global.config.S3ClientConfigurationProperties;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import software.amazon.awssdk.core.SdkResponse;
import software.amazon.awssdk.core.async.AsyncRequestBody;
import software.amazon.awssdk.core.async.AsyncResponseTransformer;
import software.amazon.awssdk.http.SdkHttpResponse;
import software.amazon.awssdk.services.s3.S3AsyncClient;
import software.amazon.awssdk.services.s3.model.GetObjectRequest;
import software.amazon.awssdk.services.s3.model.GetObjectResponse;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;
import software.amazon.awssdk.services.s3.model.PutObjectResponse;

import java.nio.ByteBuffer;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;
import java.util.concurrent.CompletableFuture;

@RestController
@RequestMapping("/upload")
@Slf4j
public class FileController {
    private final S3AsyncClient s3client;
    private final S3ClientConfigurationProperties s3config;

    public FileController(S3AsyncClient s3client, S3ClientConfigurationProperties s3config) {
        this.s3client = s3client;
        this.s3config = s3config;
    }

    @PostMapping
    public Mono<ResponseEntity<UploadResult>> uploadHandler(@RequestHeader HttpHeaders headers, @RequestBody Flux<ByteBuffer> body) {
        long length = headers.getContentLength();
        if (length < 0) {
            throw new UploadFailedException(HttpStatus.BAD_REQUEST.value(), Optional.of("required header missing: Content-Length"));
        }

        Map<String, String> metadata = new HashMap<String, String>();
        MediaType mediaType = headers.getContentType();

        if (mediaType == null) {
            mediaType = MediaType.APPLICATION_OCTET_STREAM;
        }

        String fileKey = UUID.randomUUID().toString() + "." + mediaType.getSubtype();

        log.info("[I95] uploadHandler: mediaType{}, length={}", mediaType, length);
        CompletableFuture<PutObjectResponse> future = s3client
                .putObject(PutObjectRequest.builder()
                                .bucket(s3config.getBucket())
                                .contentLength(length)
                                .key(fileKey)
                                .contentType(mediaType.toString())
                                .metadata(metadata)
                                .build(),
                        AsyncRequestBody.fromPublisher(body));

        return Mono.fromFuture(future)
                .map((response) -> {
                    checkUploadResult(response);
                    return ResponseEntity
                            .status(HttpStatus.CREATED)
                            .body(new UploadResult(HttpStatus.CREATED, new String[] {fileKey}));
                });
    }

    @GetMapping(path="/{filekey}")
    Mono<ResponseEntity<Flux<ByteBuffer>>> downloadFile(@PathVariable("filekey") String filekey) {
        GetObjectRequest request = GetObjectRequest.builder()
                .bucket(s3config.getBucket())
                .key(filekey)
                .build();

        return Mono.fromFuture(s3client.getObject(request, AsyncResponseTransformer.toPublisher()))
                .map(response -> {
                    checkDownloadResult(response.response());
                    String filename = getMetadataItem(response.response(),"filename",filekey);
                    return ResponseEntity.ok()
                            .header(HttpHeaders.CONTENT_TYPE, response.response().contentType())
                            .header(HttpHeaders.CONTENT_LENGTH, Long.toString(response.response().contentLength()))
                            .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + filename + "\"")
                            .body(Flux.from(response));
                });
    }

    private String getMetadataItem(GetObjectResponse sdkResponse, String key, String defaultValue) {
        for (Map.Entry<String, String> entry : sdkResponse.metadata()
                .entrySet()) {
            if (entry.getKey()
                    .equalsIgnoreCase(key)) {
                return entry.getValue();
            }
        }
        return defaultValue;
    }

    private static void checkUploadResult(SdkResponse result) {
        if (result.sdkHttpResponse() == null || !result.sdkHttpResponse().isSuccessful()) {
            throw new UploadFailedException(result);
        }
    }

    private static void checkDownloadResult(GetObjectResponse response) {
        SdkHttpResponse sdkResponse = response.sdkHttpResponse();
        if (sdkResponse != null && sdkResponse.isSuccessful()) {
            return;
        }

        throw new DownloadFailedException(response);
    }
}
