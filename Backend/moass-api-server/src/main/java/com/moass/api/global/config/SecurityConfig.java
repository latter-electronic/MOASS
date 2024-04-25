package com.moass.api.global.config;


import com.fasterxml.jackson.databind.ObjectMapper;
import com.moass.api.domain.user.repository.UserRepository;
import com.moass.api.global.auth.AuthConverter;
import com.moass.api.global.auth.AuthManager;
import com.moass.api.global.auth.CustomReactiveUserDetailsService;
import com.moass.api.global.auth.CustomUserDetails;
import com.moass.api.global.handler.CustomAuthenticationEntryPoint;
import com.moass.api.global.handler.CustomAuthenticationFailureHandler;
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
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.reactive.CorsConfigurationSource;
import org.springframework.web.cors.reactive.UrlBasedCorsConfigurationSource;
import org.springframework.web.util.pattern.PathPatternParser;
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
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration config = new CorsConfiguration();
        config.setAllowCredentials(true); // 자격 증명(쿠키, HTTP 인증 등)을 허용
        config.addAllowedOriginPattern("*");
        config.addAllowedMethod("*");
        config.addAllowedHeader("*"); // 모든 헤더 허용
        config.setAllowCredentials(true); // 쿠키, 인증과 관련된 헤더 등을 허용
        //config.setMaxAge(3600L); // pre-flight 요청의 최대 캐시 시간 (초)

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource(new PathPatternParser());
        source.registerCorsConfiguration("/**", config); // 모든 경로에 대해 해당 설정 적용
        return source;
    }

    @Bean
    public SecurityWebFilterChain securityWebFilterChain(
            ServerHttpSecurity http , AuthConverter jwtAuthConverter, AuthManager jwtAuthManager) {
        AuthenticationWebFilter jwtFilter = new AuthenticationWebFilter(jwtAuthManager);
        jwtFilter.setAuthenticationFailureHandler(new CustomAuthenticationFailureHandler(new ObjectMapper()));
        jwtFilter.setServerAuthenticationConverter(jwtAuthConverter);
        return http
                .authorizeExchange(auth ->
                        auth.pathMatchers("/user/login").permitAll()
                                .pathMatchers("/device/login").permitAll()
                                .pathMatchers("/user/refresh").permitAll()
                                .pathMatchers("/user/signup").permitAll()
                                .pathMatchers("/stream/**").permitAll()
                                .pathMatchers("/**").authenticated()
                                .anyExchange().permitAll()
                )
                .httpBasic(httpBasic -> httpBasic.disable())
                .formLogin(formLogin -> formLogin.disable())
                .csrf(csrf -> csrf.disable())
                .cors(cors -> cors.configurationSource(corsConfigurationSource()))
                .addFilterAt(jwtFilter, SecurityWebFiltersOrder.AUTHENTICATION)
                .exceptionHandling(authenticationManager -> authenticationManager
                        .authenticationEntryPoint(new CustomAuthenticationEntryPoint(new ObjectMapper())))
                // .cors(cors -> cors.configurationSource(corsConfigurationSource()))
                .build();
    }

}
