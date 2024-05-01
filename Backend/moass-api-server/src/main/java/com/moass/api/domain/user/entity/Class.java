package com.moass.api.domain.user.entity;

import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Table("Class")
@Getter
@Data
public class Class {

    @Id
    @Column("class_code")
    private String classCode;

    @Column("location_code")
    private String locationCode;

}
