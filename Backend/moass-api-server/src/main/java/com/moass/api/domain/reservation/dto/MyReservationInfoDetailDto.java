package com.moass.api.domain.reservation.dto;

import com.moass.api.domain.reservation.entity.Reservation;
import com.moass.api.domain.reservation.entity.ReservationInfo;
import com.moass.api.domain.user.dto.UserSearchInfoDto;
import lombok.Data;
import java.time.LocalDate;
import java.util.List;

@Data
public class MyReservationInfoDetailDto {
    private Integer infoId;

    private Integer reservationId;

    private String reservationName;

    private String colorCode;

    private String userId;

    private Integer infoState;

    private String infoName;

    private LocalDate infoDate;

    private Integer infoTime;

    private List<UserSearchInfoDto> userSearchInfoDtoList;

    public MyReservationInfoDetailDto(ReservationInfo reservationInfo, List<UserSearchInfoDto> userSearchInfoDtoList, Reservation reservation) {
        this.infoId = reservationInfo.getInfoId();
        this.reservationId = reservationInfo.getReservationId();
        this.reservationName = reservation.getReservationName();
        this.colorCode  = reservation.getColorCode();
        this.userId = reservationInfo.getUserId();
        this.infoState = reservationInfo.getInfoState();
        this.infoName = reservationInfo.getInfoName();
        this.infoDate = reservationInfo.getInfoDate();
        this.infoTime = reservationInfo.getInfoTime();
        this.userSearchInfoDtoList = userSearchInfoDtoList;
    }
}
