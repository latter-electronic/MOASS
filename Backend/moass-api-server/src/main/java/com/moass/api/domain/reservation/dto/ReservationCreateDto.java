package com.moass.api.domain.reservation.dto;

import lombok.Data;


@Data
public class ReservationCreateDto {

    private String classCode;

    private String category;

    private Integer timeLimit;

    private String reservationName;

    private String colorCode;
}
