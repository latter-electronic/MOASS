package com.moass.ws.service;

import com.moass.ws.dto.BoardMessage;

public interface BoardService {

    void enter(BoardMessage boardMessage);
    void exit(BoardMessage boardMessage);
}
