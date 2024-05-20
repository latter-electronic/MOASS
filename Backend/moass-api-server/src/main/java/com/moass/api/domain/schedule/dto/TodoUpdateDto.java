package com.moass.api.domain.schedule.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class TodoUpdateDto {
    private String todoId;

    private Boolean completedFlag;

    private String content;


}