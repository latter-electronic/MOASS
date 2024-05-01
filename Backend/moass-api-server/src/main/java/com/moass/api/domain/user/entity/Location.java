package com.moass.api.domain.user.entity;

import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Table("Location")
@Getter
@Data
public class Location {

    @Id
    @Column("location_code")
    private String locationCode;

    @Column("location_name")
    private String locationName;
}
