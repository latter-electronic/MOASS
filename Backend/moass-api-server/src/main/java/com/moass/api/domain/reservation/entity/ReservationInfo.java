package com.moass.api.domain.reservation.entity;

import com.moass.api.global.entity.Auditable;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

import java.time.LocalDate;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Table("ReservationInfo")
@Data
public class ReservationInfo extends Auditable {

    @Id
    @Column("info_id")
    private Integer infoId;

    @Column("reservation_id")
    private Integer reservationId;

    @Column("user_id")
    private String userId;

    @Column("info_state")
    private Integer infoState;

    @Column("info_name")
    private String infoName;

    @Column("info_date")
    private LocalDate infoDate;

    @Column("info_time")
    private Integer infoTime;


}
