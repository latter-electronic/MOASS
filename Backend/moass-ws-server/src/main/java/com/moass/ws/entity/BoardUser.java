package com.moass.ws.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class BoardUser {
    @Id
    @Column(name = "board_user_id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer boardUserId;

    @Column(name = "board_id")
    private Integer boardId;

    @Column(name = "user_id")
    private String userId;

    public BoardUser(Integer boardId, String userId) {
        this.boardId = boardId;
        this.userId = userId;
    }
}
