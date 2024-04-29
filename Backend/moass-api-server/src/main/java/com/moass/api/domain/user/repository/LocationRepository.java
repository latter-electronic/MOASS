package com.moass.api.domain.user.repository;

import com.moass.api.domain.user.entity.Location;
import com.moass.api.domain.user.entity.SsafyUser;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;

public interface LocationRepository  extends ReactiveCrudRepository<Location, Integer> {


}
