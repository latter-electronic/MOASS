package com.moass.ws.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class User {

    @Id
    @Column(name = "user_id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private String userId;

    @Column(name = "user_email")
    private String userEmail;

    @Column(name = "status_id")
    private Integer statusId;

    @Column(name = "password")
    private String password;

    @Column(name = "profile_img")
    private String profileImg;

    @Column(name = "background_img")
    private String backgroundImg;

    @Column(name = "layout")
    private Integer layout;

    @Column(name = "connect_flag")
    private Integer connectFlag;

    @Column(name = "position_name")
    private String  positionName;

}
