package com.moass.api.domain.user.dto;


import com.moass.api.domain.user.entity.User;
import com.moass.api.domain.user.entity.UserDetail;
import com.moass.api.domain.user.entity.UserDeviceDetail;
import com.moass.api.domain.user.entity.UserSearchDetail;
import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class UserLoginDto {
    private String userEmail;
    private String password;

    public UserLoginDto(UserDetail userDetail){
        this.userEmail = userDetail.getUserEmail();
        this.password = userDetail.getPassword();
    }

    public UserLoginDto(UserDeviceDetail userDeviceDetail){
        this.userEmail = userDeviceDetail.getUserEmail();
        this.password = userDeviceDetail.getPassword();
    }
}
