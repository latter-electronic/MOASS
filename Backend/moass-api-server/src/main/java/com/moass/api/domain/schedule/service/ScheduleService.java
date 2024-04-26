package com.moass.api.domain.schedule.service;

import com.moass.api.domain.schedule.dto.TodoDetailDto;
import com.moass.api.domain.schedule.entity.Todo;
import com.moass.api.domain.schedule.repository.TodoRepository;
import com.moass.api.global.auth.dto.UserInfo;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class ScheduleService {

    private final TodoRepository todoRepository;

    public Mono<TodoDetailDto> CreateTodo(UserInfo userInfo, String todoContent){
       Todo todo = Todo.builder()
                .userId(userInfo.getUserId())
                .content(todoContent)
                .completedFlag(false)
               .createdAt(LocalDateTime.now())
               .updatedAt(LocalDateTime.now())
               .completedAt(null)
                .build();
        return todoRepository.save(todo)
                .map(savedTodo -> new TodoDetailDto(savedTodo));


    }
}
