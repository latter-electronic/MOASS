package com.moass.api.global.auth;

import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.ReactiveAuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.ReactiveUserDetailsService;
import org.springframework.stereotype.Component;
import reactor.core.publisher.Mono;

@Component
@RequiredArgsConstructor
public class AuthManager implements ReactiveAuthenticationManager {
    final JWTService jwtService;
    final CustomReactiveUserDetailsService users;

    @Override
    public Mono<Authentication> authenticate(Authentication authentication) {
        return Mono.justOrEmpty(authentication)
                .cast(BearerToken.class)
                .flatMap(auth -> {
                    String token = auth.getCredentials();
                    if (jwtService.validateAccessToken(token)) {
                        // 액세스 토큰 유효성 검사
                        String userEmail = jwtService.getUserInfoFromToken(token).getUserEmail();
                        return processAuthentication(userEmail);
                    }
                    else {// 유효기간 지났거나, 토큰이아닌놈
                        return Mono.error(new AuthenticationException("Invalid or expired token") {
                        });
                    }
                });
    }

    private Mono<Authentication> processAuthentication(String userEmail) {
        return users.findByUserEmail(userEmail)
                .map(userDetails -> {
                    CustomUserDetails customUserDetails = (CustomUserDetails) userDetails;
                    return new UsernamePasswordAuthenticationToken(
                            customUserDetails,
                            userDetails.getPassword(),
                            userDetails.getAuthorities()
                    );
                });
    }
}
