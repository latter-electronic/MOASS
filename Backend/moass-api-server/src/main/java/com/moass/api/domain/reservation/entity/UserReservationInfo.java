package com.moass.api.domain.reservation.entity;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Table("UserReservationInfo")
@Data
public class UserReservationInfo {

    @Column("info_id")
    private int InfoId;

    @Column("user_id")
    private String userId;


}
