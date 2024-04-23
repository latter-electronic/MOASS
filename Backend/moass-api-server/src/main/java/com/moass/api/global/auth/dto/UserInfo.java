package com.moass.api.global.auth.dto;

import com.moass.api.domain.user.entity.UserProfile;
import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class UserInfo {

    private String userId;
    private String userName;
    private String userEmail;
    public static UserInfo of(UserProfile user){
        return new UserInfo(user.getUserId(), user.getUserName(), user.getUserEmail());
    }
}
