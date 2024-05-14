package com.moass.ws.service;

import com.moass.ws.dto.BoardEnterDto;
import com.moass.ws.dto.BoardRequestDto;
import com.moass.ws.dto.MessageDto;

public interface BoardService {

//    void createBoard(BoardRequestDto dto);
    void enterBoard(String message);
//    void quitBoard(BoardRequestDto dto);
    void drawBoard(String message);
}
