package com.moass.api.domain.user.entity;

import com.moass.api.global.entity.Auditable;
import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Table("Widget")
@Getter
@Data
public class Widget  extends Auditable {

    @Id
    @Column("widget_id")
    private Integer widget_id;

    @Column("user_id")
    private String userId;

    @Column("widget_img")
    private String widgetImg;

}
