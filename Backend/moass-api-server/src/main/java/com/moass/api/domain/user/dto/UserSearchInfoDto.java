package com.moass.api.domain.user.dto;

import com.moass.api.domain.user.entity.Location;
import com.moass.api.domain.user.entity.Team;
import com.moass.api.domain.user.entity.UserSearchDetail;
import com.moass.api.domain.user.entity.Class;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class UserSearchInfoDto {

    private String locationCode;
    private String locationName;
    private String classCode;
    private String teamCode;
    private String teamName;
    private String userId;
    private String userEmail;
    private String userName;
    private String positionName;
    private Integer statusId;
    private String backgroundImg;
    private String profileImg;
    private Integer jobCode;
    private Integer connectFlag;
    private Integer xCoord;
    private Integer yCoord;

    public UserSearchInfoDto(UserSearchDetail userSearchDetail){
        this.locationCode = userSearchDetail.getLocationCode();
        this.locationName = userSearchDetail.getLocationName();
        this.classCode = userSearchDetail.getClassCode();
        this.teamCode = userSearchDetail.getTeamCode();
        this.teamName = userSearchDetail.getTeamName();
        this.userId = userSearchDetail.getUserId();
        this.userEmail = userSearchDetail.getUserEmail();
        this.userName = userSearchDetail.getUserName();
        this.positionName = userSearchDetail.getPositionName();
        this.statusId = userSearchDetail.getStatusId();
        this.backgroundImg = userSearchDetail.getBackgroundImg();
        this.profileImg = userSearchDetail.getProfileImg();
        this.jobCode = userSearchDetail.getJobCode();
        this.connectFlag = userSearchDetail.getConnectFlag();
        this.xCoord = userSearchDetail.getXCoord();
        this.yCoord = userSearchDetail.getYCoord();
    }

    public UserSearchInfoDto(Location location, Class classEntity, Team team, UserSearchDetail userSearchDetail){
        this.locationCode = location.getLocationCode();
        this.locationName = location.getLocationName();
        this.classCode = classEntity.getClassCode();
        this.teamCode = team.getTeamCode();
        this.teamName = team.getTeamName();
        this.userId = userSearchDetail.getUserId();
        this.userEmail = userSearchDetail.getUserEmail();
        this.userName = userSearchDetail.getUserName();
        this.positionName = userSearchDetail.getPositionName();
        this.statusId = userSearchDetail.getStatusId();
        this.profileImg = userSearchDetail.getProfileImg();
        this.jobCode = userSearchDetail.getJobCode();
        this.connectFlag = userSearchDetail.getConnectFlag();
    }
}
