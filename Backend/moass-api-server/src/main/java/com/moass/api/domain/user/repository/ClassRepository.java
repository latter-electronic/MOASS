package com.moass.api.domain.user.repository;

import com.moass.api.domain.user.entity.Class;
import com.moass.api.domain.user.entity.UserSearchDetail;
import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

public interface ClassRepository extends ReactiveCrudRepository<Class, Integer> {


    @Query("SELECT * FROM Class " +
            "WHERE location_code = :locationCode " +
            "ORDER BY " +
            "  CAST(SUBSTRING(class_code, 1, 1) AS CHAR) ASC, " +
            "  CAST(SUBSTRING(class_code, 2) AS UNSIGNED) ASC")
    Flux<Class> findAllClassByLocationCode(String locationCode);

    Mono<Class> findByClassCode(String classCode);

    @Query("SELECT l.location_code, l.location_name, c.class_code, t.team_code, t.team_name, u.user_id, u.user_email, su.user_name, " +
            "u.position_name, u.status_id, u.profile_img, su.job_code, u.connect_flag " +
            "FROM Class c " +
            "JOIN Location l ON c.location_code = l.location_code " +
            "JOIN Team t ON c.class_code = t.class_code " +
            "JOIN SsafyUser su ON t.team_code = su.team_code " +
            "JOIN User u ON su.user_id = u.user_id " +
            "WHERE c.class_code = :classCode")
    Flux<UserSearchDetail> findAllTeamsAndUsersByClassCode(String classCode);

    @Query("SELECT EXISTS (SELECT 1 FROM Class WHERE class_code = :classCode)")
    Mono<Boolean> existsByClassCode(String classCode);

}
