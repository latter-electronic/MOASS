package com.moass.ws.controller;

import com.moass.ws.dto.BoardEnterDto;
import com.moass.ws.dto.MessageDto;
import com.moass.ws.service.BoardService;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequiredArgsConstructor
public class BoardController {

    private final BoardService boardService;

    @MessageMapping("/board/enter")
    public void enterBoard(BoardEnterDto boardEnterDto) {
        System.out.println(boardEnterDto);
        boardService.enterBoard(boardEnterDto);
    }

//    @MessageMapping("/quit")
//    public void quitBoard(BoardRequestDto dto) {
//        boardService.quitBoard(dto);
//    }

    @MessageMapping("/board/{boardId}")
    public void draw(@DestinationVariable Integer boardId, MessageDto message) {
        System.out.println(message);
        boardService.drawBoard(boardId, message);
    }
}
