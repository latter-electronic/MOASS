package com.moass.api.global.exception;

import ch.qos.logback.core.spi.ErrorCodes;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public class ApiException extends RuntimeException {

	private final ErrorCodes errorCode;
}
