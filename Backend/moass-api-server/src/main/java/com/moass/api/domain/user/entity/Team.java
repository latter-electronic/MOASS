package com.moass.api.domain.user.entity;

import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Table("Team")
@Getter
@Data
public class Team {

    @Id
    @Column("team_code")
    private String teamCode;

    @Column("team_name")
    private String teamName;

    @Column("class_code")
    private String classCode;
}
