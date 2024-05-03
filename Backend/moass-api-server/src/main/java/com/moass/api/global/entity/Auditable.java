package com.moass.api.global.entity;

import lombok.Data;
import org.springframework.data.relational.core.mapping.Column;

import java.time.LocalDateTime;

@Data
public class Auditable {
    @Column("created_at")
    private LocalDateTime createdAt;

    @Column("updated_at")
    private LocalDateTime updatedAt;

}
