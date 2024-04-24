package com.moass.api.global.auth;

import com.moass.api.global.exception.CustomException;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.ReactiveUserDetailsService;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;
import com.moass.api.domain.user.repository.UserRepository;


@RequiredArgsConstructor
@Service
public class CustomReactiveUserDetailsService implements ReactiveUserDetailsService {
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;


    @Override
    public Mono<UserDetails> findByUsername(String username) {
        return findByUserEmail(username);
    }

    public Mono<UserDetails> findByUserEmail(String userEmail) {
        return userRepository.findUserDetailByUserEmail(userEmail)
                .map(userDetail -> new CustomUserDetails(userDetail))
                .cast(UserDetails.class)
                .switchIfEmpty(Mono.error(new CustomException("사용자를 찾을 수 없습니다.", HttpStatus.NOT_FOUND)));
    }

    public Mono<Authentication> authenticate(String userEmail, String password) {
        return findByUserEmail(userEmail)
                .flatMap(userDetails -> {
                    if (passwordEncoder.matches(password, userDetails.getPassword())) {
                        return Mono.just(new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities()));
                    } else {
                        return Mono.error(new CustomException("유효하지 않은 비밀번호입니다.", HttpStatus.UNAUTHORIZED));
                    }
                });
    }
}