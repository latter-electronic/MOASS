package com.moass.api.domain.reservation.repository;

import com.moass.api.domain.reservation.entity.Reservation;
import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

public interface ReservationRepository  extends ReactiveCrudRepository<Reservation, Integer> {


    Mono<Reservation> save(Reservation reservation);

    @Query("SELECT EXISTS (SELECT 1 FROM Reservation WHERE reservation_id = :reservationId)")
    Mono<Boolean> existsByReservationId(Integer reservationId);

    Mono<Reservation> findByReservationId(Integer reservationId);

    Flux<Reservation> findByClassCode(String classCode);

    @Query("SELECT reservation_name FROM Reservation WHERE reservation_id = :reservationId")
    Mono<String> findNameById(Integer reservationId);
}
