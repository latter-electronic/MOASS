package com.moass.api.domain.reservation.repository;

import com.moass.api.domain.reservation.entity.UserCount;
import com.moass.api.domain.reservation.entity.UserReservationInfo;
import com.moass.api.domain.user.entity.UserSearchDetail;
import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

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

    @Query("DELETE FROM UserReservationInfo where info_id = :infoId")
    Mono<Void> deleteByInfoId(Integer infoId);


    @Query("SELECT l.location_code, l.location_name, c.class_code, t.team_code, t.team_name, " +
            "u.user_id, u.user_email, su.user_name, u.position_name, u.status_id, u.profile_img, su.job_code, u.connect_flag " +
            "FROM UserReservationInfo ur " +
            "INNER JOIN User u ON u.user_id = ur.user_id " +
            "INNER JOIN SsafyUser su ON u.user_id = su.user_id " +
            "INNER JOIN  Team t ON t.team_code = su.team_code " +
            "INNER JOIN Class c ON t.class_code = c.class_code " +
            "INNER JOIN Location l ON c.location_code = l.location_code " +
            "WHERE ur.info_id = :infoId " +
            "ORDER BY su.user_name ASC")
    Flux<UserSearchDetail> findUserSearchDetailByInfoId(Integer infoId);

    @Query("DELETE uri FROM UserReservationInfo uri " +
            "JOIN ReservationInfo ri ON uri.info_id = ri.info_id " +
            "WHERE ri.reservation_id = :reservationId")
    Mono<Void> deleteByReservationId(Integer reservationId);
}
