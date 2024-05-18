package com.moass.ws.service;

import com.moass.ws.dto.BoardEnterDto;
import com.moass.ws.dto.MessageDto;
import com.moass.ws.dto.UserDto;
import com.moass.ws.entity.Board;
import com.moass.ws.entity.BoardUser;
import com.moass.ws.entity.SsafyUser;
import com.moass.ws.entity.User;
import com.moass.ws.repository.BoardRepository;
import com.moass.ws.repository.BoardUserRepository;
import com.moass.ws.repository.SsafyUserRepository;
import com.moass.ws.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
@RequiredArgsConstructor
public class BoardServiceImpl implements BoardService {

    private final UserRepository userRepository;
    private final SsafyUserRepository ssafyUserRepository;
    private final BoardRepository boardRepository;
    private final BoardUserRepository boardUserRepository;

    public Board createBoard(Board board) {
        return boardRepository.save(board);
    }
    public BoardUser createBoardUser(BoardUser boardUser) { return boardUserRepository.save(boardUser); }

}
