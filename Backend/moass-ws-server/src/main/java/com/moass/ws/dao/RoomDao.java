package com.moass.ws.dao;

import com.moass.ws.model.Room;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface RoomDao extends MongoRepository<Room, String> {
}
