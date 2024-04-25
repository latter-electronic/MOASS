package com.moass.api.domain.device.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class ReqDeviceLogoutDto {
    private String deviceId;
    private String userId;
}
