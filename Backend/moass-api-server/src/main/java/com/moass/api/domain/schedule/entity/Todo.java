package com.moass.api.domain.schedule.entity;

import lombok.Builder;
import lombok.Data;
import lombok.NonNull;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

import java.time.LocalDateTime;

@Data
@Builder
@Document(collection = "todo")
public class Todo {

    @Id
    private String todoId;

    @Field("user_id")
    @NonNull
    private String userId;

    @Field("completed_flag")
    @NonNull
    private Boolean completedFlag;

    @Field("completed_at")
    private LocalDateTime completedAt;

    @Field("created_at")
    private LocalDateTime createdAt;

    @Field("updated_at")
    private LocalDateTime updatedAt;

    @Field("content")
    @NonNull
    private String content;


}

