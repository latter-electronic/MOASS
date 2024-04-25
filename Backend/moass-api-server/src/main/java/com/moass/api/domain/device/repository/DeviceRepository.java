package com.moass.api.domain.device.repository;

import com.moass.api.domain.device.entity.Device;
import com.moass.api.domain.user.entity.User;
import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import reactor.core.publisher.Mono;

public interface DeviceRepository extends ReactiveCrudRepository<Device, Integer> {

    Mono<Device> findByDeviceId(String deviceId);


}
