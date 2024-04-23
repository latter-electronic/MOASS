package com.moass.api.domain.user.controller;

import com.moass.api.domain.user.dto.UserLoginDto;
import com.moass.api.domain.user.dto.UserSignUpDto;
import com.moass.api.global.auth.JWTService;
import com.moass.api.global.response.ApiResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.ReactiveUserDetailsService;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
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

    final ReactiveUserDetailsService users;
    final JWTService jwtService;
    final PasswordEncoder encoder;
    @GetMapping("/auth")
    public Mono<String> auth(){
        return Mono.just("t");
    }

    @PostMapping("/login")
    public Mono<ResponseEntity<ApiResponse>> login(@RequestBody UserLoginDto userDto) {
        Mono<UserDetails> foundUser = users.findByUsername(userDto.getUserEmail()).defaultIfEmpty(new UserDetails() {
            @Override
            public Collection<? extends GrantedAuthority> getAuthorities() {
                return null;
            }

            @Override
            public String getPassword() {
                return null;
            }

            @Override
            public String getUsername() {
                return null;
            }

            @Override
            public boolean isAccountNonExpired() {
                return false;
            }

            @Override
            public boolean isAccountNonLocked() {
                return false;
            }

            @Override
            public boolean isCredentialsNonExpired() {
                return false;
            }

            @Override
            public boolean isEnabled() {
                return false;
            }
        });

        return foundUser.flatMap(
                u -> {
                    if(u.getUsername()==null){
                        return ApiResponse.error("User not found",HttpStatus.BAD_REQUEST);
                    }
                    if(encoder.matches(userDto.getPassword(),u.getPassword())){
                        return ApiResponse.ok("Login Success");
                    }
                    return Mono.error(new BadCredentialsException("Invalid password"));
                }
        );
    }

    @PostMapping("/signup")
    public Mono<ResponseEntity<ApiResponse>> signup(@RequestBody UserSignUpDto userDto){
        return ApiResponse.ok("good");
    }
}
