package com.moass.api.domain.oauth2.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Table("UserMMChannel")
@Data
public class UserMMChannel {

    @Column("user_id")
    private String userId;

    @Column("mm_channel_id")
    private String mmChannelId;
}
