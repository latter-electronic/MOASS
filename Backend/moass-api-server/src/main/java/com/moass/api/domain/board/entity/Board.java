package com.moass.api.domain.board.entity;

import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

import java.time.LocalDateTime;

@Table("Board")
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Board {

    @Id
    @Column("board_id")
    private Integer boardId;

    @Column("board_name")
    private String boardName;

    @Column("board_url")
    private String boardUrl;

    @Column("is_active")
    private Boolean isActive;

    @Column("completed_at")
    private LocalDateTime completedAt;
}

