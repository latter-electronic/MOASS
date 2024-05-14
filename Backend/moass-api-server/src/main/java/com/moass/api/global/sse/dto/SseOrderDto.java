package com.moass.api.global.sse.dto;

import lombok.Data;

@Data
public class SseOrderDto {

    private String command="order";

    private String type;

    private Detail data;

    public SseOrderDto(String type, String detail,String message) {
        this.type = type;
        this.data = new Detail(detail,message);

    }

    @Data
    public static class Detail {
        private String message;
        private String detail;

        public Detail(String detail, String message) {
            this.detail = detail;
            this.message = message;
        }
    }
}
