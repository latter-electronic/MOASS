package com.moass.api.domain.board.controller;

import com.moass.api.domain.board.service.BoardService;
import com.moass.api.global.annotaion.Login;
import com.moass.api.global.auth.dto.UserInfo;
import com.moass.api.global.exception.CustomException;
import com.moass.api.global.response.ApiResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.nio.ByteBuffer;

@Slf4j
@RestController
@RequestMapping("/board")
@RequiredArgsConstructor
public class BoardController {

    final BoardService boardService;

    @GetMapping
    public Mono<ResponseEntity<ApiResponse>> getBoardList(@Login UserInfo userInfo){
        return boardService.getBoardList(userInfo)
                .flatMap(boards -> ApiResponse.ok("Board 목록 조회 완료", boards))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("조회 실패 : " + e.getMessage(), e.getStatus()));
    }

    @GetMapping("/{boardUserId}")
    public Mono<ResponseEntity<ApiResponse>> getScreenshotList(@PathVariable Integer boardUserId){
        return boardService.getScreenshotList(boardUserId)
                .flatMap(screenshots -> ApiResponse.ok("Screenshot 목록 조회 완료", screenshots))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("조회 실패 : " + e.getMessage(), e.getStatus()));
    }

    @GetMapping("/screenshot/{screenshotId}")
    public Mono<ResponseEntity<ApiResponse>> getScreenshot(@PathVariable Integer screenshotId){
        return boardService.getScreenshot(screenshotId)
                .flatMap(screenshot -> ApiResponse.ok("Screenshot 조회 완료", screenshot))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("조회 실패 : " + e.getMessage(), e.getStatus()));
    }

    @PostMapping("/screenshot/{boardId}/{userId}")
    public Mono<ResponseEntity<ApiResponse>> createScreenshot(@PathVariable Integer boardId, @PathVariable String userId, @RequestHeader HttpHeaders headers, @RequestBody Flux<ByteBuffer> file){
        return boardService.screenshotUpload(boardId, userId, headers,file)
                .flatMap(fileName -> ApiResponse.ok("캡쳐 완료",fileName))
                .onErrorResume(CustomException.class,e -> ApiResponse.error("캡쳐 실패 : "+e.getMessage(), e.getStatus()));
    }

    @DeleteMapping("/screenshot/{screenshotId}")
    public Mono<ResponseEntity<ApiResponse>> deleteScreenshot(@PathVariable Integer screenshotId){
        return boardService.deleteScreenshot(screenshotId)
                .flatMap(screenshot -> ApiResponse.ok("예약 삭제 성공", screenshot))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("스크린샷 삭제 실패 : " + e.getMessage(), e.getStatus()));
    }
}
