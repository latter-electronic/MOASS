package com.moass.api.domain.schedule.entity;

import lombok.Builder;
import lombok.Data;
import org.springframework.data.mongodb.core.mapping.Document;

@Data
@Builder
@Document(collection = "curriculum")
public class Curriculum {
}
