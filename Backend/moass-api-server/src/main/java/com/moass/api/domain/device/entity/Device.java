package com.moass.api.domain.device.entity;

import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Table("Device")
@Getter
@Data
public class Device {

    @Id
    @Column("device_id")
    private String deviceId;

    @Column("user_id")
    private String userId;

    @Column("x_coord")
    private Integer xCoord;

    @Column("y_coord")
    private Integer yCoord;

    @Column("class_code")
    private String classCode;

}
