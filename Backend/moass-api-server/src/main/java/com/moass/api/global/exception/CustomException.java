package com.moass.api.global.exception;

import org.springframework.http.HttpStatus;

public class CustomException extends RuntimeException {
    private final HttpStatus status;
    private final Object data;
    public CustomException(String message, HttpStatus status) {
        super(message);
        this.status = status;
        this.data = "";
    }
    public CustomException(String message, HttpStatus status,Object data) {
        super(message);
        this.status = status;
        this.data = data;
    }

    public HttpStatus getStatus() {
        return status;
    }
    public Object getData() {
        return data;
    }
}