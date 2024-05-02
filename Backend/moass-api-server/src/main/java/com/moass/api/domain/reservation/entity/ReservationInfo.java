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
    @Column("reservation_info_id")
    private Integer reservationInfoId;

    @Column("reservation_id")
    private Integer reservationId;

    @Column("user_id")
    private String userId;

    @Column("reservation_info_state")
    private Integer reservationInfoState;

    @Column("reservation_info_name")
    private String reservationInfoName;

    @Column("reservation_info_date")
    private LocalDate reservationInfoDate;

    @Column("reservation_info_time")
    private Integer reservationInfoTime;


}
