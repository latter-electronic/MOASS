package com.moass.ws.dto;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import lombok.*;

@Builder
@Getter
@AllArgsConstructor
@NoArgsConstructor
public class UserDto {

    private String userName;
    private String profileImg;

}
