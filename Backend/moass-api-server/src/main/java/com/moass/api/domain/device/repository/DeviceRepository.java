package com.moass.api.domain.device.repository;

import com.moass.api.domain.device.entity.Device;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import reactor.core.publisher.Mono;

public interface DeviceRepository extends ReactiveCrudRepository<Device, Integer> {

    Mono<Device> findByDeviceId(String deviceId);

}
