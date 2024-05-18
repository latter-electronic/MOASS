package com.moass.ws.model;


import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

import java.util.List;

@Data
@Document
public class Room {

    @Id
    private Integer id;

    @Field
    private String name;

    @Field
    private String description;

    @Field
    List<String> participants;

    @Field
    List<Drawing> drawings;
}
