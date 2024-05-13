package com.moass.ws.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;
import java.util.Map;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class MessageDto {

    private Integer boardId;
    private List<String> ids;
    private List<String> palette;
    private Map<String, List<Integer>> data;
}
