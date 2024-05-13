package com.moass.api.global.fcm.entity;


import com.moass.api.global.entity.Auditable;
import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.CompoundIndex;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;
import org.springframework.data.relational.core.mapping.Table;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Table("FcmToken")
@Data
public class FcmToken extends Auditable {

    @Id
    @Field("fcm_token_id")
    private String fcmTokenId;

    @Field("user_id")
    private String userId;

    @Field("mobile_device_id")
    private String mobileDeviceId;

    @Field("token")
    private String token;

}