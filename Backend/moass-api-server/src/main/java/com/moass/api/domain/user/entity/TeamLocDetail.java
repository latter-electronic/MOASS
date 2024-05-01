package com.moass.api.domain.user.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Data
public class TeamLocDetail {

    private String locationCode;
    private String locationName;
    private String classCode;
    private String teamCode;
    private String teamName;
}
