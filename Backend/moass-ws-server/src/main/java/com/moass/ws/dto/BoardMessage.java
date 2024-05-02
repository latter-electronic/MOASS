package com.moass.ws.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class BoardMessage {
    private MessageType type;
    private Long boardId;
    private String sender;
    private Point point;
}
