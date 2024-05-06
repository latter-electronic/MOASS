package com.moass.api.domain.board.dto;

import com.moass.api.domain.board.entity.BoardDetail;
import lombok.AllArgsConstructor;
import lombok.Data;
import org.springframework.data.relational.core.mapping.Column;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
public class BoardDetailDto {
    private Integer boardUserId;
    private Integer boardId;
    private String boardName;
    private String boardUrl;
    private Boolean isActive;
    private LocalDateTime completedAt;

    public BoardDetailDto(BoardDetail boardDetail) {
        this.boardUserId = boardDetail.getBoardUserId();
        this.boardId = boardDetail.getBoardId();
        this.boardName = boardDetail.getBoardName();
        this.boardUrl = boardDetail.getBoardUrl();
        this.isActive = boardDetail.getIsActive();
        this.completedAt = boardDetail.getCompletedAt();
    }
}
