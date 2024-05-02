package com.moass.api.domain.seat.entity;

import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Table("Seat")
@Data
public class Seat {

    @Id
    @Column("seat_id")
    private Integer seatId;

    @Column("user_id")
    private String userId;

    @Column("x_coord")
    private Integer xCoord;

    @Column("y_coord")
    private Integer yCoord;
}
