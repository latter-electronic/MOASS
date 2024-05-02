package com.moass.api.domain.user.entity;

import com.moass.api.domain.user.dto.UserCreateDto;
import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Table("SsafyUser")
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

    @Column("card_serial_id")
    private String cardSerialId;

    public SsafyUser(UserCreateDto userCreateDto){
        this.userId = userCreateDto.getUserId();
        this.jobCode = userCreateDto.getJobCode();
        this.teamCode = userCreateDto.getTeamCode();
        this.userName = userCreateDto.getUserName();
        this.cardSerialId = userCreateDto.getCardSerialId();
    }
}
