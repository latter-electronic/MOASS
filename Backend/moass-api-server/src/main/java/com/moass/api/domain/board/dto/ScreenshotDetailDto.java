package com.moass.api.domain.board.dto;

import com.moass.api.domain.board.entity.Screenshot;
import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class ScreenshotDetailDto {
    private Integer screenshotId;
    private String screenshotUrl;

    public ScreenshotDetailDto(Screenshot screenshot) {
        this.screenshotId = screenshot.getScreenshotId();
        this.screenshotUrl = screenshot.getScreenshotUrl();
    }
}
