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
    public static UserInfo of(UserDetail user){
        return new UserInfo(user.getUserId(), user.getUserName(), user.getUserEmail());
    }

    public UserInfo(UserDetail userDetail){
        this.userId= userDetail.getUserId();
        this.userName= userDetail.getUserName();
        this.userEmail= userDetail.getUserEmail();
    }
}
