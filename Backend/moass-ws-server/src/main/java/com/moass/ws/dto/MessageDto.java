package com.moass.ws.dto;

import lombok.*;

import java.util.*;

@Getter
@Setter
@AllArgsConstructor
@ToString
public class MessageDto {

    private List<String> users;
    private List<UserDto> userDetails;
    private List<String> colors;
    private Map<String, List<Integer>> data;

    public MessageDto() {
        this.users = new ArrayList<>();
        this.userDetails = new ArrayList<>();
        this.colors = new ArrayList<>();
        this.data = new HashMap<>();
    }

}
