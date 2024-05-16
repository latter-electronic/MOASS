package com.moass.ws.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class SsafyUser {

    @Id
    @Column(name = "user_id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private String userId;

    @Column(name = "job_code")
    private Integer jobCode;

    @Column(name = "team_code")
    private String teamCode;

    @Column(name = "user_name")
    private String userName;

    @Column(name = "card_serial_id")
    private String cardSerialId;

}
