package com.moass.ws.controller;

import com.moass.ws.dto.BoardRequestDto;
import com.moass.ws.entity.Board;
import com.moass.ws.service.BoardService;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequiredArgsConstructor
public class BoardController {

    private final BoardService boardService;

    @MessageMapping("/board/create")
    public void createBoard(@Payload Integer userId) {
        boardService.createBoard(userId);
    }

    @MessageMapping("/board/enter")
    public void enterBoard(@Payload BoardRequestDto dto) {
        boardService.enterBoard(dto);
    }

    @MessageMapping("/board/quit")
    public void quitBoard(@Payload BoardRequestDto dto) {
        boardService.quitBoard(dto);
    }

    @MessageMapping("/board/draw")
    public void draw(BoardRequestDto dto) {}

    @MessageMapping("board/screenshot")
    public void screenshot(BoardRequestDto dto) {}
}
