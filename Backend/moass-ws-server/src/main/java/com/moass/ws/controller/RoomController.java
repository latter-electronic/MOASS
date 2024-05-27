package com.moass.ws.controller;

import com.moass.ws.dto.BoardRequestDto;
import com.moass.ws.entity.Board;
import com.moass.ws.entity.BoardUser;
import com.moass.ws.entity.User;
import com.moass.ws.model.Room;
import com.moass.ws.repository.UserRepository;
import com.moass.ws.service.BoardService;
import com.moass.ws.service.RoomService;
import com.moass.ws.service.UploadService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/v1/board")
@RequiredArgsConstructor
public class RoomController {

    private final RoomService roomService;
    private final BoardService boardService;
    private final UploadService uploadService;
    private final UserRepository userRepository;

    @GetMapping("/create/{userId}")
    public ResponseEntity<Board> createBoard(@PathVariable String userId) {
        Board received = boardService.createBoard(userId);

        Room room = new Room();
        room.setId(received.getBoardId());
        room.setName(received.getBoardName());
        room.setBoardUrl(received.getBoardUrl());
        room.setIsActive(received.getIsActive());
        room.setCompletedAt(received.getCompletedAt());

        List<User> userList = new ArrayList<>();
        userList.add(userRepository.findById(userId).orElseThrow());
        room.setParticipants(userList);
        roomService.save(room);

        return ResponseEntity.ok(received);
    }

    @GetMapping("/{boardId}/{userId}")
    public ResponseEntity<String> joinBoard(@PathVariable Integer boardId, @PathVariable String userId) {
        return ResponseEntity.ok(boardService.joinBoard(boardId, userId));
    }

    @GetMapping("/quit/{boardId}/{userId}")
    public void quitBoard(@PathVariable Integer boardId, @PathVariable String userId) {
        Room room = roomService.getRoom(boardId).orElseThrow();

        for (User user : room.getParticipants()) {
            if (user.getUserId().equals(userId)) {
                List<User> userList = room.getParticipants();
                userList.remove(user);
                room.setParticipants(userList);

                if (room.getParticipants().isEmpty()) {
                    room.setIsActive(false);
                    Board board = boardService.getBoard(boardId);
                    board.setIsActive(false);
                    boardService.quitBoard(board);
                }

                roomService.update(room);
                break;
            }
        }
    }

    @GetMapping("/all/{userId}")
    public List<Room> getAllRooms(@PathVariable String userId) {
        return boardService.getBoards(userId);
    }

    @PostMapping("/screenshot")
    public ResponseEntity<String> saveScreenshot(@RequestPart(value = "request")BoardRequestDto dto, @RequestPart(value = "file") MultipartFile file) throws Exception {
        String url = uploadService.uploadFile(dto.getBoardId(), dto.getUserId(), file);
        return ResponseEntity.ok(url);
    }
}
