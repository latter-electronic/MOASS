package com.moass.ws.model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class RoomActionsDTO {
    private String userId;
    private String payload;
    private Integer boardId;

    public RoomActionsDTO(String userId, String payload, Integer boardId) {
        this.userId = userId;
        this.payload = payload;
        this.boardId = boardId;
    }
}
