package com.moass.ws.service;

import com.moass.ws.dto.BoardMessage;
import com.moass.ws.dto.Point;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class BoardServiceImpl implements BoardService {

    private List<Point> points = new ArrayList<Point>();

    @Autowired
    private SimpMessagingTemplate template;

    public void enter(BoardMessage boardMessage) {
        template.convertAndSend("/sub/ws/board" + boardMessage.getBoardId(), "Enter");
    }
    public void exit(BoardMessage boardMessage) {
        template.convertAndSend("/sub/ws/board" + boardMessage.getBoardId(), "Exit");
    }
}
