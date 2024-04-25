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
        jwtFilter.setAuthenticationFailureHandler(new CustomAuthenticationFailureHandler(new ObjectMapper()));
        jwtFilter.setServerAuthenticationConverter(jwtAuthConverter);
        return http
                .authorizeExchange(auth ->
                        auth.pathMatchers("/user/login").permitAll()
                                .pathMatchers("/user/refresh").permitAll()
                                .pathMatchers("/user/signup").permitAll()
                                .pathMatchers("/test").permitAll()
                                .pathMatchers("/**").authenticated()
                                .anyExchange().permitAll()
                )
                .httpBasic(httpBasic -> httpBasic.disable())
                .formLogin(formLogin -> formLogin.disable())
                .csrf(csrf -> csrf.disable())
                .addFilterAt(jwtFilter, SecurityWebFiltersOrder.AUTHENTICATION)
                .exceptionHandling(authenticationManager -> authenticationManager
                        .authenticationEntryPoint(new CustomAuthenticationEntryPoint(new ObjectMapper())))
                // .cors(cors -> cors.configurationSource(corsConfigurationSource()))
                .build();
    }

}
