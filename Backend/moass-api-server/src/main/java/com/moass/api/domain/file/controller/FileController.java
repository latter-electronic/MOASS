package com.moass.api.domain.file.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import software.amazon.awssdk.services.s3.S3AsyncClient;

@RestController
@RequestMapping("/upload")
public class FileController {
    private final S3AsyncClient s3client;

    public FileController(S3AsyncClient s3client) {
        this.s3client = s3client;
    }
}
