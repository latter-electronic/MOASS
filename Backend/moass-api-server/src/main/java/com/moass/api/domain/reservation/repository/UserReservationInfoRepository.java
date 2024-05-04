package com.moass.api.domain.reservation.repository;

import com.moass.api.domain.reservation.entity.ReservationInfo;
import com.moass.api.domain.reservation.entity.UserCount;
import com.moass.api.domain.reservation.entity.UserReservationInfo;
import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import reactor.core.publisher.Flux;

import java.time.LocalDate;

public interface UserReservationInfoRepository   extends ReactiveCrudRepository<UserReservationInfo, Integer> {
    @Query("SELECT uri.* FROM UserReservationInfo uri " +
            "JOIN ReservationInfo ri ON uri.info_id = ri.info_id " +
            "WHERE ri.reservation_id = :reservationId AND ri.info_date = :infoDate")
    Flux<UserReservationInfo> findByReservationIdAndDate(Integer reservationId, LocalDate infoDate);

    @Query("SELECT uri.user_id, COUNT(*) as count FROM UserReservationInfo uri " +
            "JOIN ReservationInfo ri ON uri.info_id = ri.info_id " +
            "WHERE ri.reservation_id = :reservationId AND ri.info_date = :infoDate " +
            "GROUP BY uri.user_id")
    Flux<UserCount> countByReservationIdAndDate(Integer reservationId, LocalDate infoDate);

}
