package com.moass.ws.controller;

import com.amazonaws.services.s3.model.ObjectMetadata;
import com.moass.ws.entity.Board;
import com.moass.ws.entity.BoardUser;
import com.moass.ws.entity.User;
import com.moass.ws.model.Drawing;
import com.moass.ws.model.Room;
import com.moass.ws.repository.UserRepository;
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

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@RestController
@RequestMapping("/v1/board")
@RequiredArgsConstructor
public class RoomController {

    private final RoomService roomService;
    private final BoardService boardService;
    private final UploadService uploadService;
    private final UserRepository userRepository;

//    @PostMapping
//    public ResponseEntity<Room> createRoom(@RequestBody Room room) {
//        Board board = boardService.createBoard(new Board(room));
//        room.setId(board.getBoardId());
//        roomService.save(room);
//        return ResponseEntity.ok(room);
//    }

    @GetMapping("/create/{userId}")
    public ResponseEntity<String> createBoard(@PathVariable String userId) {
        String url = "http://k10e203.p.ssafy.io:5001/boards/" + UUID.randomUUID();

        Board board = new Board();
        board.setBoardUrl(url);
        Board received = boardService.createBoard(board);
        Room room = new Room();
        room.setId(received.getBoardId());
        room.setBoardUrl(received.getBoardUrl());
        room.setIsActive(true);
        room.setCompletedAt(received.getCompletedAt());

        boardService.createBoardUser(new BoardUser(board.getBoardId(), userId));

        List<User> userList = new ArrayList<>();
        userList.add(userRepository.findById(userId).orElseThrow());
        room.setParticipants(userList);
        roomService.save(room);

        return ResponseEntity.ok(url);
    }

    @GetMapping("/{boardId}/{userId}")
    public ResponseEntity<String> joinBoard(@PathVariable Integer boardId, @PathVariable String userId) {
        return ResponseEntity.ok(boardService.joinBoard(boardId, userId));
    }

//    @PostMapping("/{boardId}/save-drawing")
//    public ResponseEntity<String> saveDrawing(@PathVariable Integer boardId, @RequestBody Drawing drawing) {
//        Query query = new Query();
//        query.addCriteria(Criteria.where("id").is(boardId));
//        Update updateQuery = new Update();
//        updateQuery.push("drawings", drawing);
//        mongoTemplate.updateFirst(query, updateQuery, Room.class);
//        return ResponseEntity.ok("Drawing saved successfully!");
//    }

//    @GetMapping("/{boardId}/get-drawings")
//    public ResponseEntity<List<Drawing>> getDrawings(@PathVariable Integer boardId) {
//        List<Drawing> drawings = mongoTemplate.findById(boardId, Room.class).getDrawings();
//        return ResponseEntity.ok(drawings);
//    }

//    @GetMapping("/{id}")
//    public ResponseEntity<Room> getRoom(@PathVariable Integer id) {
//        Optional<Room> room = roomService.getRoom(id);
//        if (room.isPresent()) {
//            return new ResponseEntity<>(room.get(), HttpStatus.OK);
//        } else {
//            return new ResponseEntity<>(null, HttpStatus.BAD_REQUEST);
//        }
//    }

    @GetMapping("/all/{userId}")
    public List<Room> getAllRooms(@PathVariable String userId) {
        return boardService.getBoards(userId);
    }

    @PostMapping("/screenshot")
    public ResponseEntity<String> saveScreenshot(@RequestPart(value = "boardId") Integer boardId, @RequestPart(value = "userId") String userId, @RequestPart(value = "file") MultipartFile file) throws Exception {
        String url = uploadService.uploadFile(boardId, userId, file);
        return ResponseEntity.ok(url);
    }
}
