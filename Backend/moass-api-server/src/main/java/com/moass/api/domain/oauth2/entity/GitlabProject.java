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
@Table("GitlabProject")
@Data
public class GitlabProject {
    @Id
    @Column("gitlab_project_id")
    private String gitlabProjectId;

    @Column("gitlab_token_id")
    private Integer gitlabTokenId;

    @Column("gitlab_project_name")
    private String gitlabProjectName;
}
