package com.moass.api.domain.user.controller;

import com.moass.api.domain.user.dto.UserLoginDto;
import com.moass.api.domain.user.dto.UserSignUpDto;
import com.moass.api.global.auth.AuthManager;
import com.moass.api.global.auth.CustomReactiveUserDetailsService;
import com.moass.api.global.auth.JWTService;
import com.moass.api.global.auth.dto.UserInfo;
import com.moass.api.global.response.ApiResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.ReactiveUserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Mono;

import java.util.Collection;

@Slf4j
@RestController
@RequestMapping("/user")
@RequiredArgsConstructor
public class UserController {
    private final CustomReactiveUserDetailsService userDetailsService;
    final ReactiveUserDetailsService users;
    final JWTService jwtService;
    final PasswordEncoder encoder;
    final AuthManager authManager;
    @GetMapping("/auth")
    public Mono<String> auth(){
        return Mono.just("t");
    }

    @PostMapping("/login")
    public Mono<ResponseEntity<ApiResponse>> login(@RequestBody UserLoginDto loginDto) {
        return userDetailsService.authenticate(loginDto.getUserEmail(), loginDto.getPassword())
                .flatMap(auth -> jwtService.generateTokens((UserInfo) auth.getPrincipal()))
                .flatMap(tokens ->ApiResponse.ok("로그인 성공",tokens))
                .onErrorResume(e -> ApiResponse.error("로그인 실패", HttpStatus.UNAUTHORIZED));
    }

    @PostMapping("/signup")
    public Mono<ResponseEntity<ApiResponse>> signup(@RequestBody UserSignUpDto userDto){
        return ApiResponse.ok("good");
    }
}
