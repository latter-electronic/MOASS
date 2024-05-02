package com.moass.api.domain.reservation.entity;

import com.moass.api.domain.reservation.dto.ReservationCreateDto;
import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Table("Reservation")
@Data
public class Reservation {

    @Id
    @Column("reservation_id")
    private Integer reservationId;

    @Column("class_code")
    private String classCode;

    @Column("category")
    private String category;

    @Column("time_limit")
    private Integer timeLimit;

    @Column("reservation_name")
    private String reservationName;

    @Column("color_code")
    private String colorCode;

    public Reservation(ReservationCreateDto reservationCreateDto){
        this.classCode=reservationCreateDto.getClassCode();
        this.category=reservationCreateDto.getCategory();
        this.timeLimit=reservationCreateDto.getTimeLimit();
        this.reservationName=reservationCreateDto.getReservationName();
        this.colorCode=reservationCreateDto.getColorCode();
    }
}

