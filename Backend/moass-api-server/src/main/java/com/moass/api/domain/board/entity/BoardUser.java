package com.moass.api.domain.board.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

@Table("BoardUser")
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class BoardUser {

    @Id
    @Column("board_user_id")
    private Integer boardUserId;

    @Column("board_id")
    private Integer boardId;

    @Column("user_id")
    private String userId;
}
