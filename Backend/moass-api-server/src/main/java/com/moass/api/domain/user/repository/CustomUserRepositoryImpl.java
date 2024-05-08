package com.moass.api.domain.user.repository;

import com.moass.api.domain.user.entity.UserSearchDetail;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.r2dbc.core.R2dbcEntityTemplate;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Flux;

@Repository
public class CustomUserRepositoryImpl implements CustomUserRepository {
    private final R2dbcEntityTemplate r2dbcEntityTemplate;

    @Autowired
    public CustomUserRepositoryImpl(R2dbcEntityTemplate r2dbcEntityTemplate) {
        this.r2dbcEntityTemplate = r2dbcEntityTemplate;
    }

    @Override
    public Flux<UserSearchDetail> findAllTeamUserByTeamCode(String teamCode) {
        String query = "SELECT l.location_code, l.location_name, c.class_code, t.team_code, t.team_name, " +
                "u.user_id, u.user_email, su.user_name, u.position_name, u.status_id, u.background_img, u.profile_img, su.job_code, u.connect_flag, d.x_coord, d.y_coord " +
                "FROM Team t " +
                "INNER JOIN Class c ON t.class_code = c.class_code " +
                "INNER JOIN Location l ON c.location_code = l.location_code " +
                "INNER JOIN SsafyUser su ON t.team_code = su.team_code " +
                "INNER JOIN User u ON su.user_id = u.user_id " +
                "INNER JOIN device d ON u.user_id = d.user_id " +
                "WHERE t.team_code = :teamCode";

        return r2dbcEntityTemplate.getDatabaseClient()
                .sql(query)
                .bind("teamCode", teamCode)
                .map((row, metadata) -> new UserSearchDetail(
                        row.get("location_code", String.class),
                        row.get("location_name", String.class),
                        row.get("class_code", String.class),
                        row.get("team_code", String.class),
                        row.get("team_name", String.class),
                        row.get("user_id", String.class),
                        row.get("user_email", String.class),
                        row.get("user_name", String.class),
                        row.get("position_name", String.class),
                        row.get("status_id", Integer.class),
                        row.get("background_img", String.class),
                        row.get("profile_img", String.class),
                        row.get("job_code", Integer.class),
                        row.get("connect_flag", Integer.class),
                        row.get("x_coord", Integer.class),
                        row.get("y_coord", Integer.class)))
                .all();
    }
}