package com.moass.api.global.config;


import com.moass.api.domain.user.repository.UserRepository;
import com.moass.api.global.auth.AuthConverter;
import com.moass.api.global.auth.AuthManager;
import com.moass.api.global.auth.CustomReactiveUserDetailsService;
import com.moass.api.global.auth.CustomUserDetails;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.reactive.EnableWebFluxSecurity;
import org.springframework.security.config.web.server.SecurityWebFiltersOrder;
import org.springframework.security.config.web.server.ServerHttpSecurity;
import org.springframework.security.core.userdetails.*;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.server.SecurityWebFilterChain;
import org.springframework.security.web.server.authentication.AuthenticationWebFilter;
import reactor.core.publisher.Mono;

@Configuration
@RequiredArgsConstructor
@EnableWebFluxSecurity

public class SecurityConfig {
    private final UserRepository userRepository;

    @Bean
    public PasswordEncoder passwordencoder(){
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityWebFilterChain securityWebFilterChain(
            ServerHttpSecurity http , AuthConverter jwtAuthConverter, AuthManager jwtAuthManager) {
        AuthenticationWebFilter jwtFilter = new AuthenticationWebFilter(jwtAuthManager);

        return http
                .authorizeExchange(auth ->
                        auth.pathMatchers("/user/login").permitAll()
                                .pathMatchers("/user/refresh").permitAll()
                                .pathMatchers("/user/signup").permitAll()
                                .pathMatchers("/test").permitAll()
                                .pathMatchers("/**").authenticated()
                                .anyExchange().permitAll()
                )
                .httpBasic(httpBasic -> httpBasic.disable()) // HTTP 기본 인증 비활성화
                .formLogin(formLogin -> formLogin.disable()) // 폼 로그인을 비활성화
                .csrf(csrf -> csrf.disable())
                .addFilterAt(jwtFilter, SecurityWebFiltersOrder.AUTHENTICATION)
                // .cors(cors -> cors.configurationSource(corsConfigurationSource()))
                .build();
    }

}
