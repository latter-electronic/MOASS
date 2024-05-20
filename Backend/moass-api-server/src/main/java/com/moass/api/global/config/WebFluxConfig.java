package com.moass.api.global.config;

import com.moass.api.global.argumentresolver.LoginUserArgumentResolver;
import com.moass.api.global.auth.JWTService;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.reactive.config.WebFluxConfigurer;
import org.springframework.web.reactive.result.method.annotation.ArgumentResolverConfigurer;

@Configuration
@RequiredArgsConstructor
public class WebFluxConfig implements WebFluxConfigurer {

    private final JWTService jwtService;

    @Override
    public void configureArgumentResolvers(ArgumentResolverConfigurer configurer) {
        configurer.addCustomResolver(new LoginUserArgumentResolver(jwtService));
    }
}
