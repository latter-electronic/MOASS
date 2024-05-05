package com.moass.api.domain.board.service;

import com.moass.api.domain.board.dto.BoardDetailDto;
import com.moass.api.domain.board.dto.ScreenshotDetailDto;
import com.moass.api.domain.board.repository.BoardUserRepository;
import com.moass.api.domain.board.repository.ScreenshotRepository;
import com.moass.api.global.auth.dto.UserInfo;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import reactor.core.publisher.Mono;

import java.util.List;

@Service
@RequiredArgsConstructor
public class BoardService {

    private final BoardUserRepository boardUserRepository;
    private final ScreenshotRepository screenshotRepository;

    @Transactional
    public Mono<List<BoardDetailDto>> getBoards(UserInfo userInfo) {
        return boardUserRepository.findAllBoardDetailByUserId(userInfo.getUserId())
                .collectList()
                .map(boards -> boards.stream().map(BoardDetailDto::new).toList())
                .switchIfEmpty(Mono.error(new IllegalArgumentException("Board를 찾을 수 없습니다.")));
    }

    public Mono<List<ScreenshotDetailDto>> getScreenshots(Integer boardUserId) {
        return screenshotRepository.findByBoardUserId(boardUserId)
                .collectList()
                .map(screenshots -> screenshots.stream().map(ScreenshotDetailDto::new).toList())
                .switchIfEmpty(Mono.error(new IllegalArgumentException("Screenshot을 찾을 수 없습니다.")));
    }
}
