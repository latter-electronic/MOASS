package com.moass.api.domain.user.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Data
public class UserDeviceDetail {

    private String userId;

    private String userEmail;

    private Integer statusId;

    private String password;

    private String profileImg;

    private String backgroundImg;

    private Integer layout;

    private Integer connectFlag;

    private String positionName;

    private String cardSerialId;

    private Integer jobCode;

    private String teamCode;

    private String userName;

    private String classCode;


}
