package com.moass.api.domain.schedule.service;

import com.moass.api.domain.schedule.dto.*;
import com.moass.api.domain.schedule.entity.Todo;
import com.moass.api.domain.schedule.repository.ReactiveCurriculumRepository;
import com.moass.api.domain.schedule.repository.TodoRepository;
import com.moass.api.global.auth.dto.UserInfo;
import com.moass.api.global.exception.CustomException;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ScheduleService {

    private final TodoRepository todoRepository;
    private final ReactiveCurriculumRepository curriculumRepository;

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
                .switchIfEmpty(Mono.error(new IllegalArgumentException("Todo를 찾을 수 없습니다.")));
    }

    public Mono<TodoDetailDto> DeleteTodo(UserInfo userInfo, String todoId) {
        return todoRepository.findByTodoIdAndUserId(todoId,userInfo.getUserId())
                .switchIfEmpty(Mono.error(new IllegalArgumentException("Todo를 찾을 수 없습니다.")))
                .flatMap(todo -> todoRepository.delete(todo)
                        .thenReturn(todo)
                        .map(deletedTodo -> new TodoDetailDto(deletedTodo)));
    }

    public Mono<Object> UpdateDto(UserInfo userInfo, TodoUpdateDto todoUpdateDto) {
        return todoRepository.findByTodoIdAndUserId(todoUpdateDto.getTodoId(),userInfo.getUserId())
                .switchIfEmpty(Mono.error(new CustomException("Todo를 찾을 수 없습니다.", HttpStatus.NOT_FOUND)))
                .flatMap(todo -> {
                    boolean isUpdated = false;
                    if(todoUpdateDto.getContent() != null&&!todo.getContent().equals(todoUpdateDto.getContent())){
                        todo.setContent(todoUpdateDto.getContent());
                        isUpdated = true;
                    }
                    if(todoUpdateDto.getCompletedFlag() != null&&todo.getCompletedFlag()!=todoUpdateDto.getCompletedFlag()){
                        todo.setCompletedFlag(todoUpdateDto.getCompletedFlag());
                        isUpdated=true;
                        if(todoUpdateDto.getCompletedFlag()){
                            todo.setCompletedAt(LocalDateTime.now());
                        }else{
                            todo.setCompletedAt(null);
                        }
                    }
                    if(isUpdated) {
                        todo.setUpdatedAt(LocalDateTime.now());
                        return todoRepository.save(todo)
                                .map(savedTodo -> new TodoDetailDto(savedTodo));
                    }else{
                        return Mono.error(new CustomException("변경된 사항이 없습니다.", HttpStatus.BAD_REQUEST));
                    }
                });
    }

    public Mono<CurriculumDto> getCurriculum(String date) {
        return curriculumRepository.findByDate(date)
                //.switchIfEmpty(Mono.error(new IllegalArgumentException("Curriculum을 찾을 수 없습니다.")))
                .flatMap(curriculum -> Mono.just(new CurriculumDto(curriculum)))
                .switchIfEmpty(Mono.just(new CurriculumDto()));
    }
}
