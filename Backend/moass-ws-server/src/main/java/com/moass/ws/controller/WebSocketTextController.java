package com.moass.ws.controller;

import com.moass.ws.entity.Board;
import com.moass.ws.entity.BoardUser;
import com.moass.ws.model.ActionResponseDTO;
import com.moass.ws.model.Coordinates;
import com.moass.ws.model.Room;
import com.moass.ws.model.RoomActionsDTO;
import com.moass.ws.service.BoardService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.data.mongodb.core.query.Update;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;

@RestController
@RequiredArgsConstructor
public class WebSocketTextController {

//    private final MongoTemplate mongoTemplate;
//    private final BoardService boardService;
//
//    @MessageMapping("/send/{roomId}")
//    @SendTo("/topic/{roomId}")
//    public Coordinates sendMessage(@Payload Coordinates coordinates) {
//        return coordinates;
//    }
//
//    @MessageMapping("/send/{boardId}/user")
//    @SendTo("/topic/{boardId}/user")
//    public ActionResponseDTO joinUser(@Payload RoomActionsDTO roomActions) {
//        String userId = roomActions.getUserId();
//        String action = roomActions.getPayload();
//        Integer boardId = roomActions.getBoardId();
//
//        Query query = new Query();
//        query.addCriteria(Criteria.where("id").is(boardId));
//        Update updateQuery = new Update();
//
//        if(action.equals("CONNECT_USER")) {
//            updateQuery.push("participants", userId);
//            mongoTemplate.updateFirst(query, updateQuery, Room.class);
//            boardService.createBoardUser(new BoardUser(boardId, userId));
//
//            String message = "User " + userId + " has successfully connected!";
//            Room room = mongoTemplate.findById(boardId, Room.class);
//            return new ActionResponseDTO(message, room.getParticipants());
//        } else if(action.equals("DISCONNECT_USER")) {
//            updateQuery.pull("participants", userId);
//            mongoTemplate.updateFirst(query, updateQuery, Room.class);
//
//            // If the room is empty, delete it from DB
//            if(mongoTemplate.findById(boardId, Room.class).getParticipants().isEmpty()) {
//                Board board = boardService.updateBoard(boardId);
//                // mongoTemplate.remove(query, Room.class);
//            }
//
//            String message = "User " + userId + " has disconnected!";
//            return new ActionResponseDTO(message, mongoTemplate.findById(boardId, Room.class).getParticipants());
//        } else {
//            return new ActionResponseDTO("Not supported", new ArrayList<String>());
//        }
//    }
}
