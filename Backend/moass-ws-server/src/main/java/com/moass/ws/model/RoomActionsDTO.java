package com.moass.ws.model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class RoomActionsDTO {
    private String userId;
    private String payload;
    private String roomId;

    public RoomActionsDTO(String userId, String payload, String roomId) {
        this.userId = userId;
        this.payload = payload;
        this.roomId = roomId;
    }
}
