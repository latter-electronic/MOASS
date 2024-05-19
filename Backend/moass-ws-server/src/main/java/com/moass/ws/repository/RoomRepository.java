package com.moass.ws.repository;

import com.moass.ws.model.Room;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface RoomRepository extends MongoRepository<Room, Integer> {
}
