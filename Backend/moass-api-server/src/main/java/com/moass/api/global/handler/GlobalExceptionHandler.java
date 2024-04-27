package com.moass.api.global.handler;

import com.moass.api.global.exception.CustomException;
import com.moass.api.global.response.ApiResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.dao.DataAccessException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.bind.support.WebExchangeBindException;
import org.springframework.web.reactive.result.method.annotation.ResponseEntityExceptionHandler;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

@Slf4j
@Order(Ordered.HIGHEST_PRECEDENCE)
@RestControllerAdvice
public class GlobalExceptionHandler extends ResponseEntityExceptionHandler {

	// 커스텀 예외 처리
	@ExceptionHandler(CustomException.class)
	public Mono<ResponseEntity<ApiResponse>> handleCustomException(CustomException e) {
		return ApiResponse.error(e.getMessage(), e.getStatus());
	}

	// 데이터베이스 관련 예외 처리
	@ExceptionHandler(DataAccessException.class)
	public Mono<ResponseEntity<ApiResponse>> handleDataAccessException(DataAccessException e) {
		log.warn("dataAccessException: ", e);
		return ApiResponse.error(e.getMessage(),HttpStatus.INTERNAL_SERVER_ERROR);
	}

	@ExceptionHandler(NullPointerException.class)
	public Mono<ResponseEntity<ApiResponse>> NullPointerException(NullPointerException e) {
		log.warn("dataAccessException: ", e);
		return ApiResponse.error(e.getMessage(),HttpStatus.INTERNAL_SERVER_ERROR);
	}
	/**
	private ApiResponse<Object> makeErrorResponse(ErrorCode errorCode) {
		return ApiResponse.error(errorCode.getMessage(), errorCode.getHttpStatus());
	}

	private ApiResponse<Object> makeErrorResponse(ErrorCode errorCode, String message) {
		return ApiResponse.error(message, errorCode.getHttpStatus());
	}
	 */
}
