package com.moass.api.domain.user.repository;

import com.moass.api.domain.user.entity.UserSearchDetail;
import reactor.core.publisher.Flux;

public interface CustomUserRepository {
    Flux<UserSearchDetail> findAllTeamUserByTeamCode(String teamCode);
}
