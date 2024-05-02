package com.moass.api.domain.reservation.dto;

import lombok.Data;


@Data
public class ReservationPatchDto {

    private Integer reservationId;

    private String category;

    private Integer timeLimit;

    private String reservationName;

    private String colorCode;
}
