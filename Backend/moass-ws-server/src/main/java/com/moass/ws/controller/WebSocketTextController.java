package com.moass.ws.controller;

import com.moass.ws.dao.RoomDao;
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
import java.util.Optional;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
public class WebSocketTextController {

    @Autowired
    private BoardUserRepository boardUserRepository;

    @Autowired
    private RoomDao roomDao;

    @Autowired
    private MongoTemplate mongoTemplate;

    @Autowired
    SimpMessagingTemplate template;

    @MessageMapping("/send/{roomId}")
    @SendTo("/topic/{roomId}")
    public Coordinates sendMessage(@Payload Coordinates coordinates) {
        return coordinates;
    }

    @MessageMapping("/send/{boardId}/user")
    @SendTo("/topic/{boardId}/user")
    public ActionResponseDTO joinUser(@Payload RoomActionsDTO roomActions) {
        String userId = roomActions.getUserId();
        String action = roomActions.getPayload();
        Integer boardId = roomActions.getBoardId();

        Query query = new Query();
        query.addCriteria(Criteria.where("boardId").is(boardId));
        Update updateQuery = new Update();

        if(action.equals("CONNECT_USER")) {
            updateQuery.push("participants", userId);
            mongoTemplate.updateFirst(query, updateQuery, Room.class);

            String message = "User " + userId + " has successfully connected!";
            Room room = roomDao.findByBoardId(boardId).orElseThrow();
            return new ActionResponseDTO(message, room.getParticipants());
        } else if(action.equals("DISCONNECT_USER")) {
            updateQuery.pull("participants", userId);
            mongoTemplate.updateFirst(query, updateQuery, Room.class);

            Room room = roomDao.findByBoardId(boardId).orElseThrow();

            // If the room is empty, delete it from DB
            if(room.getParticipants().isEmpty())
                mongoTemplate.remove(query, Room.class);

            String message = "User " + userId + " has disconnected!";
            return new ActionResponseDTO(message, room.getParticipants());
        } else {
            return new ActionResponseDTO("Not supported", new ArrayList<String>());
        }
    }
}
