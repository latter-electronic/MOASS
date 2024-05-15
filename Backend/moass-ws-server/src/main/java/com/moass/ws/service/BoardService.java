package com.moass.ws.service;

import com.moass.ws.dto.BoardEnterDto;
import com.moass.ws.dto.MessageDto;

public interface BoardService {

    void enterBoard(BoardEnterDto boardEnterDto);
//    void quitBoard(BoardRequestDto dto);
    void drawBoard(Integer boardId, MessageDto message);
}
