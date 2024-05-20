package com.moass.api.domain.webhook.entity;

import com.moass.api.global.entity.Auditable;
import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

@Table("GitlabToken")
@Data
public class GitlabHook extends Auditable {

    @Id
    @Column("gitlab_token_id")
    private String gitlabTokenId;

    @Column("team_code")
    private String teamCode;

}
