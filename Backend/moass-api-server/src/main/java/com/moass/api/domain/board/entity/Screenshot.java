package com.moass.api.domain.board.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

@Table("Screenshot")
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Screenshot {

    @Id
    @Column("screenshot_id")
    private Integer screenshotId;

    @Column("board_user_id")
    private Integer boardUserId;

    @Column("screenshot_url")
    private String screenshotUrl;

    public Screenshot(Integer boardUserId, String screenshotUrl) {
        this.boardUserId = boardUserId;
        this.screenshotUrl = screenshotUrl;
    }
}
