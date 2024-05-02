package com.moass.api.domain.reservation.dto;

import lombok.Data;

import java.time.LocalDate;
import java.util.List;

@Data
public class ReservationInfoCreateDto {

        private Integer reservationId;

        private String infoName;

        private List<Integer> infoTimes;

        private LocalDate infoDate;

        private List<String> infoUsers;
}
