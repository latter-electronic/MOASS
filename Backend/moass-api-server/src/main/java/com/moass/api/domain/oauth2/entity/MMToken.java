package com.moass.api.domain.oauth2.entity;


import com.moass.api.global.entity.Auditable;
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
@Table("MMToken")
@Data
public class MMToken extends Auditable {

    @Id
    @Column("mm_token_id")
    private Integer mmTokenId;

    @Column("session_token")
    private String sessionToken;

    @Column("user_id")
    private String userId;

}
