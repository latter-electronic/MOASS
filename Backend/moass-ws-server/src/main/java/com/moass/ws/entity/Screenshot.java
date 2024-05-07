package com.moass.ws.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Screenshot {

    @Id
    @Column(name = "screenshot_id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer screenshotId;

    @Column(name = "screenshot_url")
    private String screenshotUrl;

    @Column(name = "board_user_id")
    private Integer boardUserId;
}
