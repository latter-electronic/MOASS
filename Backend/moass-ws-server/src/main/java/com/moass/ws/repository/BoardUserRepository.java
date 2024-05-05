package com.moass.ws.repository;

import com.moass.ws.entity.Board;
import com.moass.ws.entity.BoardUser;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BoardUserRepository extends JpaRepository<BoardUser, Integer> {
}
