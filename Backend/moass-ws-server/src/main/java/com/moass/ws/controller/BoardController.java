package com.moass.ws.controller;

import com.moass.ws.dto.BoardMessage;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
public class BoardController {

    @MessageMapping("/ws/enter")
    public void enter(BoardMessage dto) {}

    @MessageMapping("/ws/exit")
    public void exit(BoardMessage dto) {}

    @MessageMapping("/ws/draw")
    public void draw(BoardMessage dto) {}
}
