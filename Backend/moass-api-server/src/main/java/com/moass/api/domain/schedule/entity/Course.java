package com.moass.api.domain.schedule.entity;

import lombok.*;

@Data
@Builder
public class Course {
    private String period;
    private String majorCategory;
    private String minorCategory;
    private String title;
    private String teacher;
    private String room;
}
