package com.moass.ws.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.*;

@Entity
@Data
@Builder
public class User {

    public User() {}

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer userId;

    private String userEmail;

    private Integer statusId;

    private String password;

    private String profileImg;

    private String backgroundImg;

    private Integer layout;

    private Integer connectFlag;

    private String  positionName;
}
