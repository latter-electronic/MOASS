package com.moass.ws.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

@Service
public class BoardService {

    @Autowired
    private SimpMessagingTemplate template;

    public void enter() {
        template.convertAndSend("/sub/board/enter", "Enter");
    }
    public void exit() {}
}
