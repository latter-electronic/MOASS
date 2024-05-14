package com.moass.api.domain.user.repository;

import com.moass.api.domain.user.dto.LocationAndClassInfoDto;
import com.moass.api.domain.user.entity.Location;
import com.moass.api.domain.user.entity.UserSearchDetail;
import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;


public interface LocationRepository  extends ReactiveCrudRepository<Location, Integer> {

    Mono<Location> findByLocationCode(String locationCode);

    @Query("SELECT l.location_code, l.location_name, c.class_code, t.team_code, t.team_name, u.user_id, u.user_email, su.user_name, " +
            "u.position_name, u.status_id, u.background_img, u.profile_img, su.job_code, u.connect_flag " +
            "FROM Location l " +
            "JOIN Class c ON l.location_code = c.location_code " +
            "JOIN Team t ON c.class_code = t.class_code " +
            "JOIN SsafyUser su ON t.team_code = su.team_code " +
            "JOIN User u ON su.user_id = u.user_id " +
            "WHERE c.location_code = :locationCode")
    Flux<UserSearchDetail> findAllTeamsAndUsersByLocationCode(String locationCode);


    @Query("SELECT l.location_code, l.location_name, c.class_code " +
            "FROM Location l " +
            "JOIN Class c ON c.location_code = l.location_code "+
            "ORDER BY l.location_code, c.class_code")
    Flux<LocationAndClassInfoDto> findAllLocationAndTeamInfo();

}
