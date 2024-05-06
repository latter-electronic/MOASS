package com.moass.api.domain.reservation.dto;

import com.moass.api.domain.reservation.entity.ReservationInfo;
import lombok.Data;

import java.util.List;

@Data
public class ReservationDetailDto {
    private Integer reservationId;
    private String classCode;
    private String category;
    private Integer timeLimit;
    private String reservationName;
    private String colorCode;
    private List<ReservationInfo> reservationInfoList;
}
