package com.moass.api.global.fcm.dto;

import lombok.*;

@Getter
@ToString
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class FcmSendDto {
    private String token;

    private String title;

    private String body;

    private String icon;

    private String path;

    private String pathData;

    private String groupId;

}
