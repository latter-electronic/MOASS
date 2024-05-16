package com.moass.api.domain.oauth2.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Table("MMTeam")
@Data
public class MMTeam {

    @Id
    @Column("mm_team_id")
    private String mmTeamId;

    @Column("mm_team_name")
    private String mmTeamName;

    @Column("mm_team_icon")
    private String mmTeamIcon;
}
