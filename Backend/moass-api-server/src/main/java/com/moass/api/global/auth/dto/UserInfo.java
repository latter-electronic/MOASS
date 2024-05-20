package com.moass.api.global.auth.dto;

import com.moass.api.domain.user.entity.UserDetail;
import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class UserInfo {

    private String userId;
    private String userName;
    private String userEmail;
    private Integer jobCode;
    private String teamCode;
    public static UserInfo of(UserDetail user){
        return new UserInfo(user.getUserId(), user.getUserName(), user.getUserEmail(),user.getJobCode(), user.getTeamCode());
    }

    public UserInfo(UserDetail userDetail){
        this.userId= userDetail.getUserId();
        this.userName= userDetail.getUserName();
        this.userEmail= userDetail.getUserEmail();
        this.jobCode = userDetail.getJobCode();
        this.teamCode= userDetail.getTeamCode();
    }
}
