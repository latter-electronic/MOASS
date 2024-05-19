package com.moass.ws.repository;

import com.moass.ws.entity.Screenshot;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ScreenshotRepository extends JpaRepository<Screenshot, Integer> {
}
