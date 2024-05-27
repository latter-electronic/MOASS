package com.moass.ws.service;

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
import org.springframework.stereotype.Service;

import java.util.*;

@Service
@RequiredArgsConstructor
public class BoardServiceImpl implements BoardService {

    private final UserRepository userRepository;
    private final SsafyUserRepository ssafyUserRepository;
    private final BoardRepository boardRepository;
    private final BoardUserRepository boardUserRepository;
    private final RoomRepository roomRepository;
    private final MongoTemplate mongoTemplate;

    public Board createBoard(String userId) {
        String url = "https://k10e203.p.ssafy.io/wbo/boards/" + UUID.randomUUID();

        Board board = new Board();
        board.setBoardName("Team Board");
        board.setBoardUrl(url);
        board.setIsActive(true);
        Board received = boardRepository.save(board);

        String teamCode = ssafyUserRepository.findById(userId).orElseThrow().getTeamCode();
        List<SsafyUser> ssafyUsers = ssafyUserRepository.findAllByTeamCode(teamCode);

        for (SsafyUser ssafyUser: ssafyUsers) {
            boardUserRepository.save(new BoardUser(received.getBoardId(), ssafyUser.getUserId()));
        }

        return received;
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

        return roomRepository.findById(boardId).orElseThrow().getBoardUrl();
    }

    public Board getBoard(Integer boardId) {
        return boardRepository.findById(boardId).orElseThrow();
    }

    public void quitBoard(Board board) {
        boardRepository.save(board);
    }
}
