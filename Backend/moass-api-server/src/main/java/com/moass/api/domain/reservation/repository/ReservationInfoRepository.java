package com.moass.api.domain.reservation.repository;


import com.moass.api.domain.reservation.entity.ReservationInfo;
import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import java.time.LocalDate;

public interface ReservationInfoRepository  extends ReactiveCrudRepository<ReservationInfo, Integer> {

    @Query("SELECT info_time FROM `ReservationInfo` WHERE reservation_id = :reservationId AND info_date = :infoDate")
    Flux<Integer> findInfoTimeByReservationIdAndInfoDate(Integer reservationId, LocalDate infoDate);

    @Query("SELECT * FROM `ReservationInfo` WHERE reservation_id = :reservationId AND info_date = :infoDate  ORDER BY info_time")
    Flux<ReservationInfo> findByReservationIdAndInfoDate(Integer reservationId, LocalDate infoDate);

    @Query("SELECT * FROM `ReservationInfo` WHERE info_id = :infoId AND user_id = :userId")
    Mono<ReservationInfo> findByUserIdAndReservationInfoId(String userId, Integer infoId);

    @Query("SELECT ri.* FROM ReservationInfo ri " +
            "JOIN UserReservationInfo uri ON ri.info_id = uri.info_id " +
            "WHERE uri.user_id = :userId ")
    Flux<ReservationInfo> findByUserReservationUserId(String userId);
}
