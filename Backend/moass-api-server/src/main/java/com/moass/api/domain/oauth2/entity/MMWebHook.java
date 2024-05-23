package com.moass.api.domain.oauth2.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Table("MMWebHook")
@Data
public class MMWebHook {

    @Id
    @Column("mm_hook_id")
    private String mmHookId;

    @Column("mm_channel_id")
    private String mmChannelId;

    @Column("user_id")
    private String userId;
}
