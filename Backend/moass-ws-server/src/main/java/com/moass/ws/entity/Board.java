package com.moass.ws.entity;

import com.moass.ws.model.Room;
import jakarta.persistence.*;

import java.time.LocalDateTime;

@Entity
public class Board {

    @Id
    @Column(name = "board_id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer boardId;

    @Column(name = "board_name")
    private String boardName;

    @Column(name = "board_url")
    private String boardUrl;

    @Column(name = "is_active")
    private Boolean isActive;

    @Column(name = "completed_at")
    private LocalDateTime completedAt;

    public Board(Room room) {
        this.boardName = room.getName();
        this.boardUrl = room.getAddress();
        this.isActive = true;
    }
}
