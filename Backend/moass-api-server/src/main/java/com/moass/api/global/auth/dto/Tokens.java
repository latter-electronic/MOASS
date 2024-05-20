package com.moass.api.global.auth.dto;

import lombok.Data;

@Data
public class Tokens {

    private String accessToken;
    private String refreshToken;

}
