package com.moass.api.global.argumentresolver;

import com.moass.api.global.annotaion.Login;
import com.moass.api.global.auth.JWTService;
import com.moass.api.global.auth.dto.UserInfo;
import com.moass.api.global.exception.CustomException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.MethodParameter;
import org.springframework.http.HttpHeaders;
import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.web.reactive.BindingContext;
import org.springframework.web.reactive.result.method.HandlerMethodArgumentResolver;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

@Slf4j
@RequiredArgsConstructor
public class LoginUserArgumentResolver implements HandlerMethodArgumentResolver {

    private final JWTService jwtService;

    @Override
    public boolean supportsParameter(MethodParameter parameter) {
        log.info("supportsParameter 실행");
        boolean hasLoginAnnotation = parameter.hasParameterAnnotation(Login.class);
        boolean hasIntegerType = UserInfo.class.isAssignableFrom(parameter.getParameterType());
        return hasLoginAnnotation && hasIntegerType;
    }

    @Override
    public Mono<Object> resolveArgument(MethodParameter parameter, BindingContext bindingContext, ServerWebExchange exchange) {
        log.info("resolveArgument 실행");
        ServerHttpRequest request = exchange.getRequest();
        String authorization = request.getHeaders().getFirst(HttpHeaders.AUTHORIZATION);

        if (authorization == null || !authorization.startsWith("Bearer"))
            return Mono.empty();

        String token = authorization.substring(7);
        log.info("token={}", token);
        try {
            UserInfo userInfo = jwtService.getUserInfoFromAccessToken(token);
            return Mono.justOrEmpty(userInfo);
        } catch (CustomException e) {
            log.error("Token validation error: {}", e.getMessage());
            exchange.getResponse().setStatusCode(e.getStatus());
            return Mono.error(e);
        }
    }
}
