package com.moass.api.global.auth;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.ReactiveAuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.stereotype.Component;
import reactor.core.publisher.Mono;

@Slf4j
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
                        String userEmail = jwtService.getUserInfoFromAccessToken(token).getUserEmail();
                        return processAuthentication(userEmail);
                    }
                    else {
                        return Mono.error(new AuthenticationException("유효하지 않거나 만료된 토큰입니다.") {
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
