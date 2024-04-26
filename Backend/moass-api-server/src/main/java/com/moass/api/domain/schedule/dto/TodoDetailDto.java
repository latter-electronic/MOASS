package com.moass.api.domain.schedule.dto;

import com.moass.api.domain.schedule.entity.Todo;
import lombok.Data;
import org.springframework.data.mongodb.core.mapping.Field;

import java.time.LocalDateTime;

@Data
public class TodoDetailDto {
    private String todoId;
    private String userId;
    private String content;
    private boolean completedFlag;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private LocalDateTime completedAt;


    public TodoDetailDto(Todo todo){
        this.todoId=todo.getTodoId();
        this.userId=todo.getUserId();
        this.content=todo.getContent();
        this.completedFlag=todo.isCompletedFlag();
        this.createdAt=todo.getCreatedAt();
        this.updatedAt=todo.getUpdatedAt();
        this.completedAt=todo.getCompletedAt();
    }
}
