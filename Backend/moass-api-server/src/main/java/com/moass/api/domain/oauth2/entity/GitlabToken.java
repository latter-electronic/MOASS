package com.moass.api.domain.oauth2.entity;

import com.moass.api.global.entity.Auditable;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

import java.time.LocalDateTime;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Table("GitlabToken")
@Data
public class GitlabToken  extends Auditable {

    @Id
    @Column("gitlab_token_id")
    private Integer gitlabTokenId;

    @Column("user_id")
    private String userId;


    @Column("gitlab_email")
    private String gitlabEmail;

    @Column("access_token")
    private String accessToken;

    @Column("refresh_token")
    private String refreshToken;

    @Column("expires_at")
    private LocalDateTime expiresAt;
}
