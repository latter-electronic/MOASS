package com.moass.api.domain.user.service;


import com.moass.api.domain.user.dto.ReqFilteredUserDetailDto;
import com.moass.api.domain.user.dto.UserSignUpDto;
import com.moass.api.domain.user.entity.User;
import com.moass.api.domain.user.entity.UserDetail;
import com.moass.api.domain.user.repository.SsafyUserRepository;
import com.moass.api.domain.user.repository.UserRepository;
import com.moass.api.global.auth.JWTService;
import com.moass.api.global.auth.dto.Tokens;
import com.moass.api.global.exception.CustomException;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;

import java.util.Map;

@RequiredArgsConstructor
@Service
public class UserService {

    private final UserRepository userRepository;
    private final SsafyUserRepository ssafyUserRepository;
    private final PasswordEncoder passwordEncoder;
    private final JWTService jwtService;


    public Mono<UserDetail> signUp(UserSignUpDto userDto) {
        return userRepository.findByUserEmailOrUserId(userDto.getUserEmail(),userDto.getUserId())
                .flatMap(dbUser -> Mono.<UserDetail>error(new CustomException("사용자가 이미 존재합니다.", HttpStatus.CONFLICT)))
                .switchIfEmpty(
                        ssafyUserRepository.findByUserId(userDto.getUserId())
                                .switchIfEmpty(Mono.error(new CustomException("등록되어 있지 않는 사용자입니다.",HttpStatus.BAD_REQUEST)))
                                .flatMap(ssafyUser -> {
                                    User newUser = User.builder()
                                            .userId(ssafyUser.getUserId())
                                            .userEmail(userDto.getUserEmail())
                                            .password(passwordEncoder.encode(userDto.getPassword()))
                                            .build();
                                    return userRepository.saveForce(newUser)
                                            .map(savedUser -> new UserDetail(newUser, ssafyUser));
                                })
                );
    }


    public Mono<Tokens> refreshAccessToken(String refreshToken) {
        return Mono.defer(() -> {
                    if (!jwtService.validateRefreshToken(refreshToken)) {
                        return Mono.error(new CustomException("유효하지 않거나 만료된 토큰입니다.",HttpStatus.UNAUTHORIZED));
                    }
                    return Mono.just(refreshToken);
                })
                .flatMap(token -> Mono.justOrEmpty(jwtService.getUserInfoFromRefreshToken(token)))
                .flatMap(userInfo -> {
                    if (userInfo == null || userInfo.getUserEmail().isEmpty()) {
                        return Mono.error(new CustomException("토큰의 이메일이 유효하지 않습니다.",HttpStatus.BAD_GATEWAY));
                    }
                    return jwtService.generateTokens(userInfo);
                });
    }


    public Mono<ReqFilteredUserDetailDto> getUserDetail(String userEmail) {
        return userRepository.findUserDetailByUserEmail(userEmail)
                .switchIfEmpty(Mono.error(new CustomException("사용자가 존재하지 않습니다.", HttpStatus.NOT_FOUND)))
                .flatMap(userDetail -> Mono.just(new ReqFilteredUserDetailDto(userDetail)));
    }

}
