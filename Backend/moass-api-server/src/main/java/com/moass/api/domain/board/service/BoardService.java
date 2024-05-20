package com.moass.api.domain.board.service;

import com.moass.api.domain.board.dto.BoardDetailDto;
import com.moass.api.domain.board.dto.ScreenshotDetailDto;
import com.moass.api.domain.board.entity.Board;
import com.moass.api.domain.board.entity.Screenshot;
import com.moass.api.domain.board.repository.BoardRepository;
import com.moass.api.domain.board.repository.BoardUserRepository;
import com.moass.api.domain.board.repository.ScreenshotRepository;
import com.moass.api.domain.reservation.entity.Reservation;
import com.moass.api.domain.user.dto.UserSearchInfoDto;
import com.moass.api.global.auth.dto.UserInfo;
import com.moass.api.global.config.S3ClientConfigurationProperties;
import com.moass.api.global.exception.CustomException;
import com.moass.api.global.service.S3Service;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.nio.ByteBuffer;
import java.util.List;

@Service
@RequiredArgsConstructor
public class BoardService {

    private final BoardRepository boardRepository;
    private final BoardUserRepository boardUserRepository;
    private final ScreenshotRepository screenshotRepository;
    private final S3Service s3Service;
    private final S3ClientConfigurationProperties s3config;

    @Transactional
    public Mono<List<BoardDetailDto>> getBoardList(UserInfo userInfo) {
        return boardUserRepository.findAllBoardDetailByUserId(userInfo.getUserId())
                .collectList()
                .map(boards -> boards.stream().map(BoardDetailDto::new).toList())
                .switchIfEmpty(Mono.error(new IllegalArgumentException("Board를 찾을 수 없습니다.")));
    }

    public Mono<List<ScreenshotDetailDto>> getScreenshotList(Integer boardUserId) {
        return screenshotRepository.findByBoardUserId(boardUserId)
                .collectList()
                .map(screenshots -> screenshots.stream().map(ScreenshotDetailDto::new).toList())
                .switchIfEmpty(Mono.error(new IllegalArgumentException("Screenshot을 찾을 수 없습니다.")));
    }

    public Mono<ScreenshotDetailDto> getScreenshot(Integer screenshotId) {
        return screenshotRepository.findByScreenshotId(screenshotId)
                .switchIfEmpty(Mono.error(new CustomException("존재하지 않는 사용자입니다.", HttpStatus.NOT_FOUND)))
                .flatMap(screenshot -> Mono.just(new ScreenshotDetailDto(screenshot)));
    }

    public Mono<String> screenshotUpload(Integer boardId, String userId, HttpHeaders headers, Flux<ByteBuffer> file) {
        return s3Service.uploadHandler(headers, file)
                .flatMap(uploadResult -> {
                    if (uploadResult.getStatus() != HttpStatus.CREATED) {
                        return Mono.error(new CustomException("Image upload failed", HttpStatus.INTERNAL_SERVER_ERROR));
                    }
                    String fileKey = uploadResult.getKeys()[0];
                    return boardUserRepository.findByBoardIdAndUserId(boardId, userId)
                            .flatMap(boardUser -> {
                                Screenshot screenshot = Screenshot.builder()
                                        .boardUserId(boardUser.getBoardUserId())
                                        .screenshotUrl(s3config.getImageUrl() + "/" + fileKey)
                                        .build();
                                return screenshotRepository.save(screenshot).thenReturn(s3config.getImageUrl() + "/" + fileKey);
                            });
                });
    }

    public Mono<Screenshot> deleteScreenshot(Integer screenshotId) {
        return screenshotRepository.findByScreenshotId(screenshotId)
                .flatMap(screenshot -> screenshotRepository.delete(screenshot).thenReturn(screenshot))
                .switchIfEmpty(Mono.error(new CustomException("해당 스크린샷이 존재하지 않습니다.", HttpStatus.NOT_FOUND)));
    }
}
