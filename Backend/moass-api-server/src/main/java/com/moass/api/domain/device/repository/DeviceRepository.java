package com.moass.api.domain.device.repository;

import com.moass.api.domain.device.dto.DeviceIdDto;
import com.moass.api.domain.device.entity.Device;
import com.moass.api.domain.user.entity.User;
import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

public interface DeviceRepository extends ReactiveCrudRepository<Device, Integer> {

    Mono<Device> findByDeviceId(String deviceId);

    Mono<Device> findByUserId(String userId);

    Mono<Boolean> existsByDeviceId(String deviceId);

    @Query("SELECT CASE WHEN user_id IS NOT NULL THEN true ELSE false END FROM Device WHERE device_id = :deviceId")
    Mono<Boolean> isUserLoggedIn(String deviceId);

    @Query("SELECT * FROM Device WHERE class_code = :classCode")
    Flux<Device> findAllByClassCode(String classCode);
}
