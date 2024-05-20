package com.moass.api.domain.user.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class SenderAndReceiverUserSearchInfoDto {

    private UserSearchInfoDto ReceiverUserSearchInfoDto;
    private UserSearchInfoDto SenderUserSearchInfoDto;
}
