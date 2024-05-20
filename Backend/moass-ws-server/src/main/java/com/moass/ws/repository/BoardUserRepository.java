package com.moass.ws.repository;

import com.moass.ws.entity.BoardUser;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface BoardUserRepository extends JpaRepository<BoardUser, Integer> {
    List<BoardUser> findAllByUserId(String userId);
    BoardUser findBoardUserByBoardIdAndUserId(Integer boardId, String userId);
}
