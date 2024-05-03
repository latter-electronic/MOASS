package com.moass.ws.service;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.CannedAccessControlList;
import com.amazonaws.services.s3.model.DeleteObjectRequest;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.PutObjectRequest;
//import com.cute.gawm.common.exception.S3FileDeleteException;
//import com.cute.gawm.common.exception.S3FileUploadException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Optional;
import java.util.UUID;

@Service
public class S3Uploader {

    private final AmazonS3 amazonS3;

    @Value("${cloud.aws.s3.bucketName}")
    private String bucketName; // S3 버킷 이름 설정

    @Autowired
    public S3Uploader(AmazonS3 amazonS3) {
        this.amazonS3 = amazonS3;
    }

    public String uploadFile(MultipartFile file){
        try {
            String originalFilename = file.getOriginalFilename();
            String fileExtension = Optional.ofNullable(originalFilename)
                    .filter(f -> f.contains("."))
                    .map(f -> f.substring(originalFilename.lastIndexOf(".") + 1))
                    .orElse("");

            String uuid = UUID.randomUUID().toString();
            String fileName = uuid + (fileExtension.isEmpty() ? "" : "." + fileExtension);

            ObjectMetadata metadata = new ObjectMetadata();
            metadata.setContentLength(file.getSize());

            amazonS3.putObject(new PutObjectRequest(bucketName, fileName, file.getInputStream(), metadata)
                    .withCannedAcl(CannedAccessControlList.PublicRead));
            return fileName;
        }catch(Exception e){
            throw new S3FileUploadException("파일 업로드에 실패했습니다. :"+e.getMessage());
        }
    }

    public boolean deleteFile(String fileName) {
        try {
            amazonS3.deleteObject(new DeleteObjectRequest(bucketName, fileName));
            return true; // 삭제 성공
        } catch (Exception e) {
            throw new S3FileDeleteException("파일 삭제에 실패했습니다. 원인: " + e.getMessage());
        }
    }
}