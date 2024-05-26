package com.moass.ws.service;

import com.moass.ws.dto.BoardEnterDto;
import com.moass.ws.dto.MessageDto;
import com.moass.ws.dto.UserDto;
import com.moass.ws.entity.Board;
import com.moass.ws.entity.BoardUser;
import com.moass.ws.entity.SsafyUser;
import com.moass.ws.entity.User;
import com.moass.ws.model.Room;
import com.moass.ws.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.data.mongodb.core.query.Update;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
@RequiredArgsConstructor
public class BoardServiceImpl implements BoardService {

    private final UserRepository userRepository;
    private final BoardRepository boardRepository;
    private final BoardUserRepository boardUserRepository;
    private final RoomRepository roomRepository;
    private final MongoTemplate mongoTemplate;

    public Board createBoard(Board board) {
        return boardRepository.save(board);
    }

    public List<Room> getBoards(String userId) {
        List<BoardUser> boardUserList = boardUserRepository.findAllByUserId(userId);
        List<Room> roomList = new ArrayList<>();

        for (BoardUser boardUser : boardUserList) {
            Room room = roomRepository.findById(boardUser.getBoardId()).orElseThrow();
            if (room.getIsActive()) roomList.add(room);
        }

        return roomList;
    }

    public String joinBoard(Integer boardId, String userId) {
        Query query = new Query();
        query.addCriteria(Criteria.where("id").is(boardId));
        Update updateQuery = new Update();
        User user = userRepository.findById(userId).orElseThrow();
        updateQuery.push("participants", user);
        mongoTemplate.updateFirst(query, updateQuery, Room.class);

        boardUserRepository.save(new BoardUser(boardId, userId));

        return roomRepository.findById(boardId).orElseThrow().getBoardUrl();
    }

    public Board getBoard(Integer boardId) {
        return boardRepository.findById(boardId).orElseThrow();
    }

    public void quitBoard(Board board) {
        boardRepository.save(board);
    }

    public BoardUser createBoardUser(BoardUser boardUser) { return boardUserRepository.save(boardUser); }
}
