package com.moass.ws.controller;

import com.amazonaws.services.s3.model.ObjectMetadata;
import com.moass.ws.entity.Board;
import com.moass.ws.model.Drawing;
import com.moass.ws.model.Room;
import com.moass.ws.service.BoardService;
import com.moass.ws.service.RoomService;
import com.moass.ws.service.UploadService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.data.mongodb.core.query.Update;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/v1/rooms")
@RequiredArgsConstructor
public class RoomController {

    private final RoomService roomService;
    private final BoardService boardService;
    private final UploadService uploadService;
    private final MongoTemplate mongoTemplate;

    @PostMapping
    public ResponseEntity<Room> createRoom(@RequestBody Room room) {
        Board board = boardService.createBoard(new Board(room));
        room.setId(board.getBoardId());
        roomService.save(room);
        return ResponseEntity.ok(room);
    }

    @GetMapping("/create/{userId}")
    public ResponseEntity<String> createBoard(@PathVariable String userId) {
        Room room = new Room();
        Board board = boardService.createBoard(new Board(room));
        room.setId(board.getBoardId());
        roomService.save(room);
        return ResponseEntity.ok("https://k10e203.p.ssafy.io/room/" + board.getBoardId() + "?userId=" + userId);
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

    @PostMapping("/screenshot")
    public ResponseEntity<String> saveScreenshot(@RequestPart(value = "boardId") Integer boardId, @RequestPart(value = "userId") String userId, @RequestPart(value = "file") MultipartFile file) throws Exception {
        String url = uploadService.uploadFile(boardId, userId, file);
        return ResponseEntity.ok(url);
    }
}
