package com.moass.ws.service;

import com.moass.ws.dto.BoardRequestDto;

public interface BoardService {

    void createBoard(BoardRequestDto dto);
    void enterBoard(BoardRequestDto dto);
    void quitBoard(BoardRequestDto dto);
}
