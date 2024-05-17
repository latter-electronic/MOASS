package com.moass.ws.service;


import com.moass.ws.model.Room;

import java.util.List;
import java.util.Optional;

public interface RoomService {

    Room save(Room room);

    Room update(Room room);

    void deleteRoom(String roomId);

    Optional<Room> getRoom(Integer boardId);

    List<Room> getAllRooms();
}