package com.moass.api.domain.user.entity;

import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Table("user")
@Getter
@Data
public class SsafyUser {

    @Id
    @Column("user_id")
    private String userId;

    @Column("job_code")
    private Integer jobCode;

    @Column("team_code")
    private String teamCode;

    @Column("user_name")
    private String userName;
}
