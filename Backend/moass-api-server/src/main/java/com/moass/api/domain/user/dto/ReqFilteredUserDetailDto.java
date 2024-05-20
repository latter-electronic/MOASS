package com.moass.api.domain.user.dto;

import com.moass.api.domain.user.entity.SsafyUser;
import com.moass.api.domain.user.entity.User;
import com.moass.api.domain.user.entity.UserDetail;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Data
public class ReqFilteredUserDetailDto {

    private String userId;

    private String userEmail;

    private Integer statusId;

    private String profileImg;

    private String backgroundImg;

    private Integer layout;

    private Integer connectFlag;

    private Integer jobCode;

    private String teamCode;

    private String userName;

    private String positionName;
    public ReqFilteredUserDetailDto(User user, SsafyUser ssafyUser){
        this.userId = user.getUserId();
        this.userEmail = user.getUserEmail();
        this.statusId = user.getStatusId();
        this.profileImg = user.getProfileImg();
        this.backgroundImg = user.getBackgroundImg();
        this.layout = user.getLayout();
        this.connectFlag = user.getConnectFlag();
        this.positionName = user.getPositionName();
        this.jobCode = ssafyUser.getJobCode();
        this.teamCode = ssafyUser.getTeamCode();
        this.userName = ssafyUser.getUserName();
    }

    public ReqFilteredUserDetailDto(UserDetail userDetail){
        this.userId = userDetail.getUserId();
        this.userEmail = userDetail.getUserEmail();
        this.statusId = userDetail.getStatusId();
        this.profileImg = userDetail.getProfileImg();
        this.backgroundImg = userDetail.getBackgroundImg();
        this.layout = userDetail.getLayout();
        this.connectFlag= userDetail.getConnectFlag();
        this.jobCode = userDetail.getJobCode();
        this.teamCode = userDetail.getTeamCode();
        this.userName = userDetail.getUserName();
        this.positionName = userDetail.getPositionName();
    }



}