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

    private final Map<Integer, MessageDto> boards = new HashMap<>();
    private final SimpMessagingTemplate template;
    private final UserRepository userRepository;
    private final SsafyUserRepository ssafyUserRepository;
    private final BoardRepository boardRepository;
    private final BoardUserRepository boardUserRepository;

    private final String[] colors = {"", "000000", "ff0000", "0000ff", "008000", "ff7f00", "8b00ff"};

    public void createBoard(Board board) {
        boardRepository.save(board);
    }

    public void enterBoard(BoardEnterDto boardEnterDto) {
        if (!boards.containsKey(boardEnterDto.getBoardId())) {
            boards.put(boardEnterDto.getBoardId(), new MessageDto());
        }

        if (!boards.get(boardEnterDto.getBoardId()).getUsers().contains(boardEnterDto.getUserId())) {
            boardUserRepository.save(new BoardUser(boardEnterDto.getBoardId(), boardEnterDto.getUserId()));
            boards.get(boardEnterDto.getBoardId()).getUsers().add(boardEnterDto.getUserId());

            User user = userRepository.findById(boardEnterDto.getUserId()).orElseThrow();
            SsafyUser ssafyUser = ssafyUserRepository.findById(boardEnterDto.getUserId()).orElseThrow();

            UserDto userDto = UserDto.builder()
                    .userName(ssafyUser.getUserName())
                    .profileImg(user.getProfileImg())
                    .build();

            boards.get(boardEnterDto.getBoardId()).getUserDetails().add(userDto);
            boards.get(boardEnterDto.getBoardId()).getColors().add(colors[boards.get(boardEnterDto.getBoardId()).getUsers().size()]);
        }

        template.convertAndSend("/topic/board/" + boardEnterDto.getBoardId(), boards.get(boardEnterDto.getBoardId()));
    }

//    public void quitBoard(BoardRequestDto dto) {
//        boards.get(dto.getBoardId()).remove(userRepository.findById(dto.getUserId()).orElseThrow());
//
//        template.convertAndSend("/topic/board/" + dto.getBoardId(), BoardResponseDto.builder()
//                .boardId(dto.getBoardId())
//                .users(boards.get(dto.getBoardId()))
//                .build());
//    }

    public void drawBoard(Integer boardId, MessageDto message) {
        boards.replace(boardId, message);
        template.convertAndSend("/topic/board/" + boardId, message);
    }
}
