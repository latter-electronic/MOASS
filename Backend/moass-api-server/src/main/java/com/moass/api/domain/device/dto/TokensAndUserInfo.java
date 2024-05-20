package com.moass.api.domain.device.dto;

import com.moass.api.global.auth.dto.Tokens;
import com.moass.api.global.auth.dto.UserInfo;
import lombok.Data;

@Data
public class TokensAndUserInfo {
    private UserInfo userInfo;
    private Tokens tokens;

    public TokensAndUserInfo(UserInfo userInfo, Tokens tokens) {
        this.userInfo = userInfo;
        this.tokens = tokens;
    }
}
