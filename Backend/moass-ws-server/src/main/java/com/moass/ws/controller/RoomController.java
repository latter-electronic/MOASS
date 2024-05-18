package com.moass.ws.controller;

import com.moass.ws.entity.Board;
import com.moass.ws.model.Drawing;
import com.moass.ws.model.Room;
import com.moass.ws.service.BoardService;
import com.moass.ws.service.RoomService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.data.mongodb.core.query.Update;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/v1/rooms")
@RequiredArgsConstructor
public class RoomController {

    private final RoomService roomService;
    private final BoardService boardService;
    private final MongoTemplate mongoTemplate;

    @PostMapping
    public ResponseEntity<Room> createRoom(@RequestBody Room room) {
        Board board = boardService.createBoard(new Board(room));
        room.setId(board.getBoardId());
        roomService.save(room);
        return ResponseEntity.ok(room);
    }

    @PostMapping("/{boardId}/save-drawing")
    public ResponseEntity<String> saveDrawing(@PathVariable Integer boardId, @RequestBody Drawing drawing) {
        Query query = new Query();
        query.addCriteria(Criteria.where("id").is(boardId));
        Update updateQuery = new Update();
        updateQuery.push("drawings", drawing);
        mongoTemplate.updateFirst(query, updateQuery, Room.class);
        return ResponseEntity.ok("Drawing saved successfully!");
    }

    @GetMapping("/{boardId}/get-drawings")
    public ResponseEntity<List<Drawing>> getDrawings(@PathVariable Integer boardId) {
        List<Drawing> drawings = mongoTemplate.findById(boardId, Room.class).getDrawings();
        return ResponseEntity.ok(drawings);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Room> getRoom(@PathVariable Integer id) {
        Optional<Room> room = roomService.getRoom(id);
        if (room.isPresent()) {
            return new ResponseEntity<>(room.get(), HttpStatus.OK);
        } else {
            return new ResponseEntity<>(null, HttpStatus.BAD_REQUEST);
        }
    }

    @GetMapping("/all")
    public List<Room> getAllRooms() {
        return roomService.getAllRooms();
    }
}
