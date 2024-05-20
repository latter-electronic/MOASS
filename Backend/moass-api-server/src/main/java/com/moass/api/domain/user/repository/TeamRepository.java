package com.moass.api.domain.user.repository;

import com.moass.api.domain.user.entity.Team;
import com.moass.api.domain.user.entity.UserDetail;
import com.moass.api.domain.user.entity.UserSearchDetail;
import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

public interface TeamRepository  extends ReactiveCrudRepository<Team, String> {


    @Query("SELECT t.team_code, t.team_name, t.class_code, c.class_name, l.location_code, l.location_name " +
            "FROM Team t " +
            "JOIN Class c ON t.class_code = c.class_code " +
            "JOIN Location l ON c.location_code = l.location_code " +
            "WHERE t.team_code = :teamCode")
    Flux<UserDetail> findAllByTeamCode(String teamCode) ;
    Mono<Team> findByTeamCode(String teamCode);

    @Query("SELECT l.location_code, l.location_name, c.class_code, t.team_code, t.team_name, " +
            "u.user_id, u.user_email, su.user_name, u.position_name, u.status_id, u.background_img, u.profile_img, su.job_code, u.connect_flag " +
            "FROM Team t " +
            "INNER JOIN Class c ON t.class_code = c.class_code " +
            "INNER JOIN Location l ON c.location_code = l.location_code " +
            "INNER JOIN SsafyUser su ON t.team_code = su.team_code " +
            "INNER JOIN User u ON su.user_id = u.user_id " +
            "WHERE t.team_code = :teamCode")
    Flux<UserSearchDetail> findTeamUserByTeamCode(String teamCode);

    @Query(" SELECT t.* " +
            "FROM User u " +
            "INNER JOIN SsafyUser su ON u.user_id = su.user_id " +
            "INNER JOIN Team t ON su.team_code = t.team_code " +
            "WHERE u.user_id = :userId")
    Mono<Team> findByUserId(String userId);
}
