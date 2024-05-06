package com.moass.api.domain.reservation.dto;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import lombok.AllArgsConstructor;
import lombok.Data;


@Data
@AllArgsConstructor
public class ReservationCreateDto {

    private String classCode;

    private String category;

    @Min(value = 1, message = "시간 제한은 최소 30분 이상이어야 합니다.")
    @Max(value = 10, message = "시간 제한은 최대 5시간을 초과할 수 없습니다.")
    private Integer timeLimit;

    private String reservationName;

    private String colorCode;


}