package com.moass.ws.model;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class ActionResponseDTO {
    private String message;
    private List<String> users;

    public ActionResponseDTO(String message, List<String> users) {
        this.message = message;
        this.users = users;
    }
}
