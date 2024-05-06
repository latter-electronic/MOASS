package com.moass.api.global.handler;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.moass.api.global.response.ApiResponse;
import org.springframework.core.io.buffer.DataBuffer;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.server.WebFilterExchange;
import org.springframework.security.web.server.authentication.ServerAuthenticationFailureHandler;
import reactor.core.publisher.Mono;

import java.nio.charset.StandardCharsets;

public class CustomAuthenticationFailureHandler implements ServerAuthenticationFailureHandler {
    private final ObjectMapper objectMapper;

    public CustomAuthenticationFailureHandler(ObjectMapper objectMapper) {
        this.objectMapper = objectMapper;
    }


    @Override
    public Mono<Void> onAuthenticationFailure(WebFilterExchange webFilterExchange, AuthenticationException exception) {
        ApiResponse<String> apiResponse = new ApiResponse<>("Authentication failed", HttpStatus.UNAUTHORIZED.value());
        webFilterExchange.getExchange().getResponse().setStatusCode(HttpStatus.UNAUTHORIZED);
        webFilterExchange.getExchange().getResponse().getHeaders().setContentType(MediaType.APPLICATION_JSON);
        try {
            String jsonResponse = objectMapper.writeValueAsString(apiResponse);
            DataBuffer dataBuffer = webFilterExchange.getExchange().getResponse().bufferFactory().wrap(jsonResponse.getBytes(StandardCharsets.UTF_8));
            return webFilterExchange.getExchange().getResponse().writeWith(Mono.just(dataBuffer));
        } catch (JsonProcessingException e) {
            return Mono.error(e); // JSON 변환에 실패한 경우 에러를 반환
        }
    }
}