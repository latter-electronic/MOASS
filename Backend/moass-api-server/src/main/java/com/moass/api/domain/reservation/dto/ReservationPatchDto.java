package com.moass.api.domain.reservation.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDate;
import java.util.List;


@Data
@AllArgsConstructor
@NoArgsConstructor
public class ReservationPatchDto {

    private Integer reservationId;

    private String category;

    private Integer timeLimit;

    private String reservationName;

    private String colorCode;

    private LocalDate infoDate;

    private List<Integer> infoTimes;

    public ReservationPatchDto(Integer reservationId, String category, Integer timeLimit, String reservationName, String colorCode){
        this.reservationId = reservationId;
        this.category = category;
        this.timeLimit = timeLimit;
        this.reservationName = reservationName;
        this.colorCode = colorCode;
    }
}
