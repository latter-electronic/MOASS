package com.moass.ws.service;

import com.moass.ws.dto.BoardEnterDto;
import com.moass.ws.dto.MessageDto;
import com.moass.ws.entity.Board;

public interface BoardService {

    Board createBoard(Board board);
    void enterBoard(BoardEnterDto boardEnterDto);
//    void quitBoard(BoardRequestDto dto);
    void drawBoard(Integer boardId, MessageDto message);
}
