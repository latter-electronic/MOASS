package com.moass.ws.service;

import com.moass.ws.dto.BoardEnterDto;
import com.moass.ws.dto.MessageDto;
import com.moass.ws.entity.Board;
import com.moass.ws.entity.BoardUser;

public interface BoardService {

    Board createBoard(Board board);
    BoardUser createBoardUser(BoardUser boardUser);
}
