package com.moass.api.domain.user.dto;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;

@Data
public class UserUpdateDto {

    private String userId;

    private String userEmail;

    private Integer statusId;

    private String password;

    private String profileImg;

    private String backgroundImg;

    private Integer layout;

    private Integer connectFlag;

    private String  positionName;

    private String teamName;

}
