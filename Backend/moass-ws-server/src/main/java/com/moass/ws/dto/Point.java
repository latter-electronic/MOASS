package com.moass.ws.dto;

import lombok.*;

import java.util.List;

@AllArgsConstructor
public class Point {
    private String peer;
    private Integer timestamp;
    private List<Integer> rgb;
}
