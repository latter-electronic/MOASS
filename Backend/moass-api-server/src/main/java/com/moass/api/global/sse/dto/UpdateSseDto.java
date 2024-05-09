package com.moass.api.global.sse.dto;

import lombok.Data;

@Data
public class UpdateSseDto {

    private String command="update";

    private String target;

    private String data;

    public UpdateSseDto(String target, String data) {
        this.target = target;
        this.data = data;
    }

}
