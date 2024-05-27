package com.moass.ws.service;

import com.moass.ws.dto.BoardEnterDto;
import com.moass.ws.dto.MessageDto;
import com.moass.ws.entity.Board;
import com.moass.ws.entity.BoardUser;
import com.moass.ws.model.Room;

import java.util.List;

public interface BoardService {

    Board createBoard(String userId);
    List<Room> getBoards(String userId);
    String joinBoard(Integer boardId, String userId);
    Board getBoard(Integer boardId);
    void quitBoard(Board board);
}
