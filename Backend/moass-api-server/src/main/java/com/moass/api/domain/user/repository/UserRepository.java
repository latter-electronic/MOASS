package com.moass.api.domain.user.repository;

import com.moass.api.domain.user.entity.User;
import com.moass.api.domain.user.entity.UserDetail;
import com.moass.api.domain.user.entity.UserSearchDetail;
import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import reactor.core.publisher.Mono;

public interface UserRepository extends ReactiveCrudRepository<User, Integer> {

    @Query("SELECT u.user_id, u.user_email, u.status_id, u.password, u.profile_img, u.background_img, " +
            "u.layout, u.connect_flag, s.card_serial_id, s.job_code, s.team_code, s.user_name ,u.position_name " +
            "FROM User u INNER JOIN SsafyUser s ON u.user_id = s.user_id " +
            "WHERE u.user_email = :userEmail")
    Mono<UserDetail> findUserDetailByUserEmail(String userEmail);

    @Query("SELECT l.location_code, l.location_name, c.class_code, t.team_code, t.team_name, " +
            "u.user_id, u.user_email, su.user_name, u.position_name, u.status_id, u.background_img, u.profile_img, su.job_code, u.connect_flag , d.x_coord, d.y_coord " +
            "FROM User u " +
            "INNER JOIN SsafyUser su ON u.user_id = su.user_id " +
            "LEFT JOIN Device d ON u.user_id = d.user_id " +
            "INNER JOIN Team t ON t.team_code = su.team_code " +
            "INNER JOIN Class c ON c.class_code = t.class_code " +
            "INNER JOIN Location l ON l.location_code = c.location_code " +
            "WHERE u.user_email = :userEmail")
    Mono<UserSearchDetail> findUserSearchDetailByUserEmail(String userEmail);

    @Query("SELECT l.location_code, l.location_name, c.class_code, t.team_code, t.team_name, " +
            "u.user_id, u.user_email, su.user_name, u.position_name, u.status_id, u.background_img, u.profile_img, su.job_code, u.connect_flag , d.x_coord, d.y_coord " +
            "FROM User u " +
            "INNER JOIN SsafyUser su ON u.user_id = su.user_id " +
            "LEFT JOIN Device d ON u.user_id = d.user_id " +
            "INNER JOIN Team t ON t.team_code = su.team_code " +
            "INNER JOIN Class c ON c.class_code = t.class_code " +
            "INNER JOIN Location l ON l.location_code = c.location_code " +
            "WHERE u.user_id = :userId")
    Mono<UserSearchDetail> findUserSearchDetailByUserId(String userId);

    Mono<User> findByUserEmail(String userEmail);

    Mono<User> findByUserEmailOrUserId(String userEmail, String userId);

    @Query("INSERT INTO `User` (user_id, user_email, password) " +
            "VALUES (:#{#user.userId}, :#{#user.userEmail}, :#{#user.password})")
    Mono<User> saveForce(User user);

    Mono<User>  findByUserId(String userId);

    @Query("SELECT EXISTS(SELECT 1 FROM User WHERE user_id = :userId)")
    Mono<Boolean> existsByUserId(String userId);
}

