package com.moass.ws.controller;

import com.moass.ws.model.ActionResponseDTO;
import com.moass.ws.model.Coordinates;
import com.moass.ws.model.Room;
import com.moass.ws.model.RoomActionsDTO;
import com.moass.ws.repository.BoardUserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.data.mongodb.core.query.Update;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
public class WebSocketTextController {

    @Autowired
    private BoardUserRepository boardUserRepository;

    @Autowired
    private MongoTemplate mongoTemplate;

    @Autowired
    SimpMessagingTemplate template;

    @MessageMapping("/send/{roomId}")
    @SendTo("/topic/{roomId}")
    public Coordinates sendMessage(@Payload Coordinates coordinates) {
        return coordinates;
    }

    @MessageMapping("/send/{roomId}/user")
    @SendTo("/topic/{roomId}/user")
    public ActionResponseDTO joinUser(@Payload RoomActionsDTO roomActions) {
        String userId = roomActions.getUserId();
        String action = roomActions.getPayload();
        String roomId = roomActions.getRoomId();

        Query query = new Query();
        query.addCriteria(Criteria.where("id").is(roomId));
        Update updateQuery = new Update();

        if(action.equals("CONNECT_USER")) {
            updateQuery.push("participants", userId);
            mongoTemplate.updateFirst(query, updateQuery, Room.class);

            String message = "User " + userId + " has successfully connected!";
            Room room = mongoTemplate.findById(roomId, Room.class);
            return new ActionResponseDTO(message, room.getParticipants());
        } else if(action.equals("DISCONNECT_USER")) {
            updateQuery.pull("participants", userId);
            mongoTemplate.updateFirst(query, updateQuery, Room.class);

            // If the room is empty, delete it from DB
            if(mongoTemplate.findById(roomId, Room.class).getParticipants().size() == 0)
                mongoTemplate.remove(query, Room.class);

            String message = "User " + userId + " has disconnected!";
            return new ActionResponseDTO(message, mongoTemplate.findById(roomId, Room.class).getParticipants());
        } else {
            return new ActionResponseDTO("Not supported", new ArrayList<String>());
        }
    }
}
