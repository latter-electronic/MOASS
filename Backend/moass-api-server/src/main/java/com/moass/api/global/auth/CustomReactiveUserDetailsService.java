package com.moass.api.global.auth;

import com.moass.api.domain.user.entity.UserProfile;
import com.moass.api.global.auth.dto.UserInfo;
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


@Service
public class CustomReactiveUserDetailsService implements ReactiveUserDetailsService {
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    public CustomReactiveUserDetailsService(UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public Mono<UserDetails> findByUsername(String username) {
        // 여기서 username은 실제로 userEmail을 의미합니다.
        return findByUserEmail(username);
    }

    public Mono<UserDetails> findByUserEmail(String userEmail) {
        return userRepository.findByUserEmail(userEmail)
                .map(userProfile -> new CustomUserDetails(userProfile))
                .cast(UserDetails.class)
                .switchIfEmpty(Mono.error(new UsernameNotFoundException("사용자를 찾을 수 없습니다.")));
    }

    public Mono<Authentication> authenticate(String userEmail, String password) {
        return findByUserEmail(userEmail)
                .flatMap(userDetails -> {
                    if (passwordEncoder.matches(password, userDetails.getPassword())) {
                        UserInfo userInfo = UserInfo.of((UserProfile) userDetails);
                        return Mono.just(new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities()));
                    } else {
                        return Mono.error(new BadCredentialsException("Invalid Credentials"));
                    }
                });
    }
}