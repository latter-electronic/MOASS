package com.moass.ws.repository;

import com.moass.ws.entity.SsafyUser;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface SsafyUserRepository extends JpaRepository<SsafyUser, String> {
    List<SsafyUser> findAllByTeamCode(String teamCode);
}
