package com.moass.api.domain.board.repository;

import com.moass.api.domain.board.entity.BoardUser;
import com.moass.api.domain.board.entity.Screenshot;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

public interface ScreenshotRepository extends ReactiveCrudRepository<Screenshot, Integer> {
    Flux<Screenshot> findByBoardUserId(Integer boardUserId);
    Mono<Screenshot> findByScreenshotId(Integer screenshotId);
}
