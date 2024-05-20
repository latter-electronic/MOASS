package com.moass.api.domain.device.dto;


import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class ReqDeviceLoginDto {
    private String deviceId;
    private String cardSerialId;
}
