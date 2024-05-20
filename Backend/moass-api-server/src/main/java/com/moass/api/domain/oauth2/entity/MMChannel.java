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
@Table("MMChannel")
@Data
public class MMChannel {

    @Id
    @Column("mm_channel_id")
    private String mmChannelId;

    @Column("mm_channel_name")
    private String mmChannelName;

    @Column("mm_team_id")
    private String mmTeamId;
}
