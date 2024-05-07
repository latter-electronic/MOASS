package com.moass.api.domain.reservation.dto;

import lombok.Data;

import java.util.List;


@Data
public class ReservationPatchDto {

    private Integer reservationId;

    private String category;

    private Integer timeLimit;

    private String reservationName;

    private String colorCode;

    private List<Integer> infoTimes;
}
