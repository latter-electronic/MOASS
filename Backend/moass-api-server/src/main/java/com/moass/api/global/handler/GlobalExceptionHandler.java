package com.moass.api.global.handler;

import com.moass.api.global.exception.CustomException;
import com.moass.api.global.response.ApiResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.dao.DataAccessException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.bind.support.WebExchangeBindException;
import org.springframework.web.reactive.result.method.annotation.ResponseEntityExceptionHandler;
import org.springframework.web.server.ServerWebExchange;
import org.springframework.web.server.ServerWebInputException;
import reactor.core.publisher.Mono;

import javax.naming.AuthenticationException;
import java.nio.file.AccessDeniedException;
import java.util.stream.Collectors;

@Slf4j
@Order(Ordered.HIGHEST_PRECEDENCE)
@RestControllerAdvice
public class GlobalExceptionHandler {

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
	public Mono<ResponseEntity<ApiResponse>> nullPointerException(NullPointerException e) {
		log.warn("dataAccessException: ", e);
		return ApiResponse.error(e.getMessage(),HttpStatus.INTERNAL_SERVER_ERROR);
	}

	@ExceptionHandler(IllegalAccessException.class)
	public Mono<ResponseEntity<ApiResponse>> IllegalAccessException(IllegalAccessException e) {
		log.warn("dataAccessException: ", e);
		return ApiResponse.error(e.getMessage(),HttpStatus.INTERNAL_SERVER_ERROR);
	}

	@ExceptionHandler(IllegalArgumentException.class)
	public Mono<ResponseEntity<ApiResponse>> IllegalArgumentException(IllegalArgumentException e) {
		log.warn("dataAccessException: ", e);
		return ApiResponse.error(e.getMessage(),HttpStatus.INTERNAL_SERVER_ERROR);
	}
	@ExceptionHandler(HttpMessageNotReadableException.class)
	public Mono<ResponseEntity<ApiResponse>> handleHttpMessageNotReadableException(HttpMessageNotReadableException e) {
		log.warn("HttpMessageNotReadableException: ", e);
		return ApiResponse.error("Invalid request content", HttpStatus.BAD_REQUEST);
	}

	@ExceptionHandler(WebExchangeBindException.class)
	public Mono<ResponseEntity<ApiResponse>> handleWebExchangeBindException(WebExchangeBindException e) {
		log.warn("WebExchangeBindException: ", e);
		String errorMessages = e.getBindingResult().getFieldErrors().stream()
				.map(fieldError -> fieldError.getDefaultMessage())
				.collect(Collectors.joining(", "));

		return ApiResponse.error("유효하지 않은 body값이 담겨있습니다. : " + errorMessages, HttpStatus.BAD_REQUEST);
	}

	@ExceptionHandler(ServerWebInputException.class)
	public Mono<ResponseEntity<ApiResponse>> handleServerWebInputException(ServerWebInputException e) {
		log.warn("ServerWebInputException: ", e);
		return ApiResponse.error("body가 존재하지 않습니다.: " + e.getMessage(), (HttpStatus) e.getStatusCode());
	}

	@ExceptionHandler(org.springframework.security.access.AccessDeniedException.class)
	public Mono<ResponseEntity<ApiResponse>> handleAccessDeniedException(org.springframework.security.access.AccessDeniedException e) {
		log.warn("권한부족");
		return ApiResponse.error("접근 권한이 없습니다.", HttpStatus.FORBIDDEN);
	}

	@ExceptionHandler(org.springframework.security.core.AuthenticationException.class)
	public Mono<ResponseEntity<ApiResponse>> handleAuthenticationException(org.springframework.security.core.AuthenticationException e) {
		log.warn("인증실패");
		return ApiResponse.error("인증에 실패했습니다.",HttpStatus.UNAUTHORIZED);
	}


	// 기타 예외처리
	@ExceptionHandler(Exception.class)
	public Mono<ResponseEntity<ApiResponse>> handleException(Exception e) {
		log.error("Exception: ", e);
		return ApiResponse.error("내부 서버 에러 : "+e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
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
