package com.moass.api.domain.board.controller;

import com.moass.api.domain.board.service.BoardService;
import com.moass.api.global.annotaion.Login;
import com.moass.api.global.auth.dto.UserInfo;
import com.moass.api.global.exception.CustomException;
import com.moass.api.global.response.ApiResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Mono;

@Slf4j
@RestController
@RequestMapping("/board")
@RequiredArgsConstructor
public class BoardController {

    final BoardService boardService;

    @GetMapping
    public Mono<ResponseEntity<ApiResponse>> getTodo(@Login UserInfo userInfo){
        return boardService.getBoards(userInfo)
                .flatMap(boards -> ApiResponse.ok("Board 목록 조회 완료", boards))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("조회 실패 : " + e.getMessage(), e.getStatus()));
    }

    @GetMapping("/screenshot/{boardUserId}")
    public Mono<ResponseEntity<ApiResponse>> getScreenshot(@PathVariable Integer boardUserId){
        return boardService.getScreenshots(boardUserId)
                .flatMap(screenshots -> ApiResponse.ok("Screenshot 목록 조회 완료", screenshots))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("조회 실패 : " + e.getMessage(), e.getStatus()));
    }
}
