package com.moass.api.domain.schedule.entity;

import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

import java.time.LocalDateTime;
import java.util.List;

@Data
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "curriculum")
public class Curriculum {
    @Id
    private String curriculumId;

    @Field("date")
    private String date;

    @Field("courses")
    private List<Course> courses;
}
