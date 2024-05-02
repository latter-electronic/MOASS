package com.moass.ws.controller;

import com.moass.ws.dto.BoardRequestDto;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class BoardController {

    @MessageMapping("/ws/enter")
    public void enter(BoardRequestDto dto) {}

    @MessageMapping("/ws/exit")
    public void exit(BoardRequestDto dto) {}

    @MessageMapping("/ws/board")
    public void board(BoardRequestDto dto) {}
}
