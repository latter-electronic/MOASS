package com.moass.api.domain.user.dto;


import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class UserSignUpDto {
    private String userEmail;
    private String userId;
    private String password;
}
