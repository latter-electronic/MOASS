package com.moass.api.domain.board.repository;

import com.moass.api.domain.board.entity.BoardDetail;
import com.moass.api.domain.board.entity.BoardUser;
import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

public interface BoardUserRepository extends ReactiveCrudRepository<BoardUser, Integer> {
    @Query("SELECT bu.board_user_id, b.board_id, b.board_name, b.board_url, b.is_active " +
            "FROM BoardUser bu JOIN Board b ON bu.board_id = b.board_id " +
            "WHERE bu.user_id = :userId")
    Flux<BoardDetail> findAllBoardDetailByUserId(String userId);

    Mono<BoardUser> findByBoardIdAndUserId(Integer boardId, String userId);

    Flux<BoardUser> findByUserId(String userId);
}
