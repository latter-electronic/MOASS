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
@Table("JiraToken")
@Data
public class JiraToken  extends Auditable {
    @Id
    @Column("jira_token_id")
    private Integer jiraTokenId;

    @Column("user_id")
    private String userId;

    @Column("cloud_id")
    private String cloudId;

    @Column("jira_email")
    private String jiraEmail;

    @Column("access_token")
    private String accessToken;

    @Column("refresh_token")
    private String refreshToken;

    @Column("expires_at")
    private LocalDateTime expiresAt;

    public JiraToken(String accessToken, String refreshToken) {
        this.accessToken = accessToken;
        this.refreshToken = refreshToken;
    }
}
