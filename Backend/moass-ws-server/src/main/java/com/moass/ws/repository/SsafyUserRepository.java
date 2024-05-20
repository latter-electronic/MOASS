package com.moass.ws.repository;

import com.moass.ws.entity.SsafyUser;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SsafyUserRepository extends JpaRepository<SsafyUser, String> {
}
