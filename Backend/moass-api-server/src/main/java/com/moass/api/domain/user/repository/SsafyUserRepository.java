package com.moass.api.domain.user.repository;

import com.moass.api.domain.user.entity.SsafyUser;
import com.moass.api.domain.user.entity.User;
import com.moass.api.domain.user.entity.UserDetail;
import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

public interface SsafyUserRepository extends ReactiveCrudRepository<SsafyUser, Integer> {

    Mono<SsafyUser> findByUserId(String userId);
    Mono<SsafyUser> findByCardSerialId(String cardSerialId);

    @Query("SELECT u.user_id, u.user_email, u.status_id, u.password, u.profile_img, u.background_img, " +
            "u.layout, u.connect_flag, s.card_serial_id, s.job_code, s.team_code, s.user_name,u.position_name " +
            "FROM SsafyUser s INNER JOIN User u ON u.user_id = s.user_id " +
            "WHERE s.card_serial_id = :cardSerialId")
    Mono<UserDetail> findUserDetailByCardSerialId(String cardSerialId);;

    @Query("SELECT u.user_id, u.user_email, u.status_id, u.password, u.profile_img, u.background_img, " +
            "u.layout, u.connect_flag, s.card_serial_id, s.job_code, s.team_code, s.user_name, u.position_name " +
            "FROM SsafyUser s INNER JOIN User u ON u.user_id = s.user_id " +
            "WHERE s.user_name = :userName AND s.job_code <= :jobCode "+
            "ORDER BY s.user_id ASC")
    Flux<UserDetail> findAllUserDetailByuserName(String userName,Integer jobCode);
}
