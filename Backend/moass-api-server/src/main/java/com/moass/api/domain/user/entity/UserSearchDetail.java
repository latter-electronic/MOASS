package com.moass.api.domain.user.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.relational.core.mapping.Column;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Data
public class UserSearchDetail {

        @Column("location_code")
        private String locationCode;

        @Column("location_name")
        private String locationName;

        @Column("class_code")
        private String classCode;

        @Column("team_code")
        private String teamCode;

        @Column("team_name")
        private String teamName;

        @Column("user_id")
        private String userId;

        @Column("user_email")
        private String userEmail;

        @Column("user_name")
        private String userName;

        @Column("position_name")
        private String positionName;

        @Column("status_id")
        private Integer statusId;

        @Column("background_img")
        private String backgroundImg;
        @Column("profile_img")
        private String profileImg;

        @Column("job_code")
        private Integer jobCode;

        @Column("connect_flag")
        private Integer connectFlag;

        @Column("x_coord")
        private Integer xCoord;

        @Column("y_coord")
        private Integer yCoord;

}
