package com.moass.api.domain.schedule.service;

import com.moass.api.domain.schedule.dto.TodoCreateDto;
import com.moass.api.domain.schedule.dto.TodoDetailDto;
import com.moass.api.domain.schedule.entity.Todo;
import com.moass.api.domain.schedule.repository.TodoRepository;
import com.moass.api.global.auth.dto.UserInfo;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ScheduleService {

    private final TodoRepository todoRepository;

    public Mono<TodoDetailDto> CreateTodo(UserInfo userInfo, TodoCreateDto todoContent){
       Todo todo = Todo.builder()
                .userId(userInfo.getUserId())
                .content(todoContent.getContent())
                .completedFlag(false)
               .createdAt(LocalDateTime.now())
               .updatedAt(LocalDateTime.now())
               .completedAt(null)
                .build();
        return todoRepository.save(todo)
                .map(savedTodo -> new TodoDetailDto(savedTodo));


    }

    public Mono<List<TodoDetailDto>> getTodo(UserInfo userInfo) {
        return todoRepository.findAllByUserId(userInfo.getUserId(),Sort.by(Sort.Direction.ASC,"createdAt"))
                .collectList()
                .map(todos -> todos.stream().map(TodoDetailDto::new).toList())
                .switchIfEmpty(Mono.error(new IllegalArgumentException("Todo not found")));
    }
}
