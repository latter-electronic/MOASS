package com.moass.api.domain.user.dto;

import com.moass.api.domain.user.entity.Widget;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class WidgetDetailDto {

    private Integer widgetId;

    private String userId;

    private String widgetImg;

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;

    public WidgetDetailDto(Widget widget){
        this.widgetId = widget.getWidget_id();
        this.userId = widget.getUserId();
        this.widgetImg = widget.getWidgetImg();
        this.createdAt = widget.getCreatedAt();
        this.updatedAt = widget.getUpdatedAt();
    }

}
