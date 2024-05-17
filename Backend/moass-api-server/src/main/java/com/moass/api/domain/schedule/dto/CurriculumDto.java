package com.moass.api.domain.schedule.dto;

import com.moass.api.domain.schedule.entity.Course;
import com.moass.api.domain.schedule.entity.Curriculum;
import lombok.AllArgsConstructor;
import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Field;

import java.util.List;

@Data
@AllArgsConstructor
public class CurriculumDto {
    private String curriculumId;
    private String date;
    private List<Course> courses;

    public CurriculumDto(Curriculum curriculum) {
        this.curriculumId = curriculum.getCurriculumId();
        this.date = curriculum.getDate();
        this.courses = curriculum.getCourses();
    }
}