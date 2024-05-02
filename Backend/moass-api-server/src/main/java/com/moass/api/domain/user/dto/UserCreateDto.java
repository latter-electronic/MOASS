package com.moass.api.domain.user.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UserCreateDto {

    private String userId;

    private Integer jobCode;

    private String teamCode;

    private String userName;

    private String cardSerialId;

}
