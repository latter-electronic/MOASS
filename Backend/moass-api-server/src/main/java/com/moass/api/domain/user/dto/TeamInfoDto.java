package com.moass.api.domain.user.dto;

import com.moass.api.domain.user.entity.UserSearchDetail;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
public class TeamInfoDto {

    private String teamCode;
    private String teamName;
    private List<UserSearchInfoDto> users;

}
