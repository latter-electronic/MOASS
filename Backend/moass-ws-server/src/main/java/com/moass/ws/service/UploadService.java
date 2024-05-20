package com.moass.ws.service;

import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.moass.ws.entity.BoardUser;
import com.moass.ws.entity.Screenshot;
import com.moass.ws.repository.BoardUserRepository;
import com.moass.ws.repository.ScreenshotRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class UploadService {

    private final AmazonS3Client amazonS3Client;
    private final BoardUserRepository boardUserRepository;
    private final ScreenshotRepository screenshotRepository;

    @Value("${aws.s3.bucket}")
    private String bucketName;

    private String defaultUrl = "https://moassbucket.s3.ap-northeast-2.amazonaws.com";

    @Transactional
    public String uploadFile(Integer boardId, String userId, MultipartFile file) throws IOException {

        String bucketDir = bucketName;
        String dirUrl = defaultUrl + "/";
        String fileName = generateFileName(file);

        amazonS3Client.putObject(bucketDir, fileName, file.getInputStream(), getObjectMetadata(file));

        BoardUser boardUser = boardUserRepository.findBoardUserByBoardIdAndUserId(boardId, userId);
        Screenshot screenshot = Screenshot.builder()
                .screenshotUrl(dirUrl + fileName)
                .boardUserId(boardUser.getBoardUserId())
                .build();
        screenshotRepository.save(screenshot);

        return dirUrl + fileName;

    }

    private ObjectMetadata getObjectMetadata(MultipartFile file) {
        ObjectMetadata objectMetadata = new ObjectMetadata();
        objectMetadata.setContentType(file.getContentType());
        objectMetadata.setContentLength(file.getSize());
        return objectMetadata;
    }

    private String generateFileName(MultipartFile file) {
        return UUID.randomUUID() + "-" + file.getOriginalFilename();
    }
}
