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

}
