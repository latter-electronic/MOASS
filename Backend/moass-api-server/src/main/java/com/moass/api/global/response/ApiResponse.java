package com.moass.api.global.response;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import reactor.core.publisher.Mono;

import java.time.Instant;
import java.time.format.DateTimeFormatter;

@Getter
@AllArgsConstructor(access = AccessLevel.PRIVATE)
public class ApiResponse<T> {

	private final T data;
	private final String message;
	private final String timestamp;
	private final int status;

	ApiResponse(T data, String message, int status) {
		this.data = data;
		this.message = message;
		this.status = status;
		this.timestamp = DateTimeFormatter.ISO_INSTANT.format(Instant.now());
	}

	public ApiResponse(String message, int value) {
		this.data = (T) "";
		this.message = message;
		this.status = value;
		this.timestamp = DateTimeFormatter.ISO_INSTANT.format(Instant.now());
	}


	public static  Mono<ResponseEntity<ApiResponse>> ok(String message, Object data) {
		ApiResponse response = new ApiResponse(data, message,200);
		return Mono.just(ResponseEntity.status(200).body(response));
	}

	public static  Mono<ResponseEntity<ApiResponse>> ok(String message) {
		ApiResponse response = new ApiResponse(message,200);
		return Mono.just(ResponseEntity.status(200).body(response));
	}

	public static Mono<ResponseEntity<ApiResponse>> error(String message, HttpStatus status) {
		ApiResponse response = new ApiResponse(null,message, status.value());
		return Mono.just(ResponseEntity.status(status).body(response));
	}

	public static Mono<ResponseEntity<ApiResponse>> error(String message, HttpStatus status,Object data) {
		ApiResponse response = new ApiResponse(data,message, status.value());
		return Mono.just(ResponseEntity.status(status).body(response));
	}
}
