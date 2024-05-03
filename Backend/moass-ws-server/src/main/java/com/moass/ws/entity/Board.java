package com.moass.ws.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Data
@Builder
public class Board {

    public Board() {}

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer boardId;

    private String BoardUrl;

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;

    private String BoardName;
}
