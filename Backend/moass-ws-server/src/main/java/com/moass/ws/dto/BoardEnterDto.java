package com.moass.ws.dto;

import lombok.*;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class BoardEnterDto {
    private Integer boardId;
    private String userId;
}
