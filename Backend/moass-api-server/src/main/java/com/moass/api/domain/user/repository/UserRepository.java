package com.moass.api.domain.user.repository;

import com.moass.api.domain.user.entity.User;
import com.moass.api.domain.user.entity.UserProfile;
import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import reactor.core.publisher.Mono;

public interface UserRepository extends ReactiveCrudRepository<User, Integer> {

    Mono<User> findByUsername(String username);
    @Query("SELECT u.user_id, u.user_email, u.status_id, u.password, u.profile_img, u.background_img, " +
            "u.rayout, u.connect_flag, u.card_serial_id, s.job_code, s.team_code, s.user_name " +
            "FROM User u INNER JOIN SsafyUser s ON u.user_id = s.user_id " +
            "WHERE u.user_email = :userEmail")
    Mono<UserProfile> findByUserEmail(String userEmail);
}

