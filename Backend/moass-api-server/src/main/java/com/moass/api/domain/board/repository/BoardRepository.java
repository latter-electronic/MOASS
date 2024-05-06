package com.moass.api.domain.board.repository;

import com.moass.api.domain.board.entity.Board;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;

public interface BoardRepository extends ReactiveCrudRepository<Board, Integer> {
}
