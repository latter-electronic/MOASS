package com.moass.api.domain.user.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Data
public class UserDetail {

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

    public UserDetail(User user, SsafyUser ssafyUser){
        this.userId = user.getUserId();
        this.userEmail = user.getUserEmail();
        this.statusId = user.getStatusId();
        this.password = user.getPassword();
        this.profileImg = user.getProfileImg();
        this.backgroundImg = user.getBackgroundImg();
        this.layout = user.getLayout();
        this.connectFlag = user.getConnectFlag();
        this.positionName = user.getPositionName();
        this.cardSerialId = ssafyUser.getCardSerialId();
        this.jobCode = ssafyUser.getJobCode();
        this.teamCode = ssafyUser.getTeamCode();
        this.userName = ssafyUser.getUserName();
    }


}
