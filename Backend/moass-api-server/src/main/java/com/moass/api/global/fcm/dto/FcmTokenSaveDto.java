package com.moass.api.global.fcm.dto;

import lombok.Data;

@Data
public class FcmTokenSaveDto {
    private String mobileDeviceId;
    private String fcmToken;
}
