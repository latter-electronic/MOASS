package com.moass.api.global.response;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import reactor.core.publisher.Mono;

@Getter
@AllArgsConstructor(access = AccessLevel.PRIVATE)
public class ApiResponse<T> {

	private final T data;
	private final String message;
	private final long timestamp;
	private final int status;

	ApiResponse( String message, T data, int status) {
		this(data, message, System.currentTimeMillis(), status);
	}

	ApiResponse(String message, int status) {
		this((T)"", message, System.currentTimeMillis(), status);
	}


	public static <T> Mono<ResponseEntity<ApiResponse>> ok(String message, T data) {
		ApiResponse response = new ApiResponse(message, data,200);
		return Mono.just(ResponseEntity.status(200).body(response));
	}

	public static <T> Mono<ResponseEntity<ApiResponse>> ok(String message) {
		ApiResponse response = new ApiResponse(message,200);
		return Mono.just(ResponseEntity.status(200).body(response));
	}

	public static Mono<ResponseEntity<ApiResponse>> error(String message, HttpStatus status) {
		ApiResponse response = new ApiResponse(message,null, status.value());
		return Mono.just(ResponseEntity.status(status).body(response));
	}
}
