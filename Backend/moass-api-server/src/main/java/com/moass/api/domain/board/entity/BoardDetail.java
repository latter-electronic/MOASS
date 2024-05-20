package com.moass.api.domain.board.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.relational.core.mapping.Column;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class BoardDetail {

    @Column("board_user_id")
    private Integer boardUserId;

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
