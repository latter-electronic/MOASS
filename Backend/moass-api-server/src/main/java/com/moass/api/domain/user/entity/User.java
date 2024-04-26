package com.moass.api.domain.user.entity;

import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Table("user")
@Getter
@Data
public class User {

    @Id
    @Column("user_id")
    private String userId;

    @Column
    private String userEmail;

    @Column("status_id")
    private Integer statusId;

    @Column("password")
    private String password;

    @Column("profile_img")
    private String profileImg;

    @Column("background_img")
    private String backgroundImg;

    @Column("rayout")
    private Integer rayout;

    @Column("connect_flag")
    private Integer connectFlag;

    @Column("position_name")
    private String  positionName;

    public User(String userEmail,String userId, String password){
        this.userEmail = userEmail;
        this.userId = userId;
        this.password = password;
    }

}
