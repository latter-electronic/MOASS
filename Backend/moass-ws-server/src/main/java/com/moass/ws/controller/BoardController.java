package com.moass.ws.controller;

import com.moass.ws.dto.BoardRequestDto;
import com.moass.ws.entity.Board;
import com.moass.ws.service.BoardService;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
//@RequestMapping("/board")
@RequiredArgsConstructor
public class BoardController {

    private final BoardService boardService;

    @MessageMapping("/create")
    public void createBoard(BoardRequestDto boardRequestDto) {
        boardService.createBoard(boardRequestDto);
    }

    @MessageMapping("/enter")
    public void enterBoard(BoardRequestDto boardRequestDto) {
        System.out.println("enter");
        boardService.enterBoard(boardRequestDto);
    }

    @MessageMapping("/quit")
    public void quitBoard(BoardRequestDto dto) {
        boardService.quitBoard(dto);
    }

    @MessageMapping("/draw")
    public void draw(String message) {
        System.out.println("draw");
        boardService.drawBoard(message);
    }
}
