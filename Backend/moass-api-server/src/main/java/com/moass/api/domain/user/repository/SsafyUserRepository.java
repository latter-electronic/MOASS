package com.moass.api.domain.user.repository;

import com.moass.api.domain.user.entity.*;
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
            "u.layout, u.connect_flag, s.card_serial_id, s.job_code, s.team_code, s.user_name,u.position_name, c.class_code " +
            "FROM SsafyUser s INNER JOIN User u ON u.user_id = s.user_id " +
            "INNER JOIN Team t ON t.team_code = s.team_code " +
            "INNER JOIN Class c ON c.class_code = t.class_code " +
            "WHERE s.card_serial_id = :cardSerialId")
    Mono<UserDeviceDetail> findUserDeviceDetailByCardSerialId(String cardSerialId);;


    @Query("SELECT u.user_id, u.user_email, u.status_id, u.password, u.profile_img, u.background_img, " +
            "u.layout, u.connect_flag, s.card_serial_id, s.job_code, s.team_code, s.user_name, u.position_name " +
            "FROM SsafyUser s INNER JOIN User u ON u.user_id = s.user_id " +
            "WHERE s.user_name = :userName AND s.job_code <= :jobCode "+
            "ORDER BY s.user_id ASC")
    Flux<UserDetail> findAllUserDetailByuserName(String userName,Integer jobCode);

    @Query("SELECT l.location_code, l.location_name, c.class_code, t.team_code, t.team_name, " +
            "u.user_id, u.user_email, su.user_name, u.position_name, u.status_id, u.background_img, u.profile_img, su.job_code, u.connect_flag " +
            "FROM SsafyUser su " +
            "INNER JOIN User u ON u.user_id = su.user_id " +
            "INNER JOIN Team t ON t.team_code = su.team_code " +
            "INNER JOIN Class c ON c.class_code = t.class_code " +
            "INNER JOIN Location l ON l.location_code = c.location_code " +
            "WHERE su.user_name LIKE  CONCAT('%', :userName, '%') AND su.job_code <= :jobCode "+
            "ORDER BY su.user_id ASC")
    Flux<UserSearchDetail> findAllUserSearchDetailByuserName(String userName, Integer jobCode);

    @Query("SELECT EXISTS(SELECT 1 FROM SsafyUser WHERE user_name = LIKE CONCAT('%', :userName, '%') AND job_code <= :jobCode)")
    Mono<Boolean> exisisByUserName(String userName, Integer jobCode);

    @Query("INSERT INTO `SsafyUser` (user_id, job_code, team_code,user_name,card_serial_id) " +
            "VALUES (:#{#ssafyUser.userId}, :#{#ssafyUser.jobCode}, :#{#ssafyUser.teamCode}, :#{#ssafyUser.userName}, :#{#ssafyUser.cardSerialId})")
    Mono<SsafyUser> saveForce(SsafyUser ssafyUser);

    @Query("SELECT s.team_code FROM SsafyUser s " +
            "WHERE s.user_id = :userId")
    Mono<String> findTeamCodeByUserId(String userId);

    @Query("SELECT c.class_code FROM SsafyUser s " +
            "INNER JOIN Team t ON s.team_code = t.team_code " +
            "INNER JOIN Class c ON t.class_code = c.class_code " +
            "WHERE s.user_id = :userId")
    Mono<String> findClassCodeByUserId(String userId);

    @Query("SELECT CASE WHEN COUNT(1) > 0 THEN true ELSE false END " +
            "FROM SsafyUser su " +
            "WHERE su.user_name LIKE CONCAT('%', :userName, '%') AND su.job_code <= :jobCode")
    Mono<Boolean> existsByUserNameAndJobCode( String userName, Integer jobCode);
}
