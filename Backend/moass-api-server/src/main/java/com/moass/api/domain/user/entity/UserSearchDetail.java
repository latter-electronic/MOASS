package com.moass.api.domain.user.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Data
public class UserSearchDetail {

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
        private String profileImg;
        private Integer jobCode;
        private Integer connectFlag;

}
