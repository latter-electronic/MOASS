package com.moass.api.global.config;


import com.fasterxml.jackson.databind.ObjectMapper;
import com.moass.api.domain.user.repository.UserRepository;
import com.moass.api.global.auth.AuthConverter;
import com.moass.api.global.auth.AuthManager;
import com.moass.api.global.handler.CustomAccessDeniedHandler;
import com.moass.api.global.handler.CustomAuthenticationEntryPoint;
import com.moass.api.global.handler.CustomAuthenticationFailureHandler;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.method.configuration.EnableReactiveMethodSecurity;
import org.springframework.security.config.annotation.web.reactive.EnableWebFluxSecurity;
import org.springframework.security.config.web.server.SecurityWebFiltersOrder;
import org.springframework.security.config.web.server.ServerHttpSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.server.SecurityWebFilterChain;
import org.springframework.security.web.server.authentication.AuthenticationWebFilter;
import org.springframework.security.web.server.util.matcher.NegatedServerWebExchangeMatcher;
import org.springframework.security.web.server.util.matcher.OrServerWebExchangeMatcher;
import org.springframework.security.web.server.util.matcher.PathPatternParserServerWebExchangeMatcher;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.reactive.CorsConfigurationSource;
import org.springframework.web.cors.reactive.UrlBasedCorsConfigurationSource;
import org.springframework.web.util.pattern.PathPatternParser;


@Configuration
@RequiredArgsConstructor
@EnableWebFluxSecurity
@EnableReactiveMethodSecurity
public class SecurityConfig {
    private final UserRepository userRepository;

    @Bean
    public PasswordEncoder passwordencoder() {
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

    /**
     * Todo
     * 접근권한 수정필요(테스트용으로 넣어둔거 빼기)
     *
     * @param http
     * @param jwtAuthConverter
     * @param jwtAuthManager
     * @return
     */
    @Bean
    public SecurityWebFilterChain securityWebFilterChain(
            ServerHttpSecurity http, AuthConverter jwtAuthConverter, AuthManager jwtAuthManager) {
        AuthenticationWebFilter jwtFilter = new AuthenticationWebFilter(jwtAuthManager);
        jwtFilter.setAuthenticationFailureHandler(new CustomAuthenticationFailureHandler(new ObjectMapper()));
        jwtFilter.setServerAuthenticationConverter(jwtAuthConverter);
        OrServerWebExchangeMatcher pathsToExclude = new OrServerWebExchangeMatcher(
                new PathPatternParserServerWebExchangeMatcher("/user/login"),
                new PathPatternParserServerWebExchangeMatcher("/user/refresh"),
                new PathPatternParserServerWebExchangeMatcher("/user/signup")
        );
        NegatedServerWebExchangeMatcher pathsToInclude = new NegatedServerWebExchangeMatcher(pathsToExclude);
        jwtFilter.setRequiresAuthenticationMatcher(pathsToInclude);
        return http
                .authorizeExchange(auth ->
                        auth.pathMatchers("/device/login", "/device/islogin").permitAll()
                                .pathMatchers("/user/signup","/user/insertuser","/user/refresh","user/login","user/profileimg").permitAll()
                                .pathMatchers("/stream/**").permitAll()
                                .pathMatchers("/upload/**").permitAll()
                                .pathMatchers("/oauth2/jira/callback").permitAll()
                                .pathMatchers("/oauth2/gitlab/callback").permitAll()
                                .pathMatchers("/device/coordinate/{deviceId}").permitAll()
                                .pathMatchers("/webhook/**").permitAll()
                                .pathMatchers("/**").authenticated()
                                .anyExchange().permitAll()
                )
                .httpBasic(httpBasic -> httpBasic.disable())
                .formLogin(formLogin -> formLogin.disable())
                .csrf(csrf -> csrf.disable())
                .cors(cors -> cors.configurationSource(corsConfigurationSource()))
                .addFilterAt(jwtFilter, SecurityWebFiltersOrder.AUTHENTICATION)
                .exceptionHandling(authenticationManager -> authenticationManager
                        .authenticationEntryPoint(new CustomAuthenticationEntryPoint(new ObjectMapper()))
                        .accessDeniedHandler(new CustomAccessDeniedHandler(new ObjectMapper())))
                .build();
    }

}
