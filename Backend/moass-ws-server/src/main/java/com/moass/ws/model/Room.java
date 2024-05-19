package com.moass.ws.model;


import com.moass.ws.entity.User;
import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

import java.time.LocalDateTime;
import java.util.List;

@Data
@Document
public class Room {

    @Id
    private Integer id;

    @Field
    private String name;

    @Field
    private String boardUrl;

    @Field
    private Boolean isActive;

    @Field
    List<User> participants;

    @Field
    LocalDateTime completedAt;
}
