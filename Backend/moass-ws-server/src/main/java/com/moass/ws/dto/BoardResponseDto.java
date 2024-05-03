package com.moass.ws.dto;

import com.moass.ws.entity.User;
import lombok.Builder;
import lombok.Data;

import java.util.Set;

@Data
@Builder
public class BoardResponseDto {
    private Integer boardId;
    private String boardUrl;
    private Set<User> users;
}
