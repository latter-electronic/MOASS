package com.moass.api.domain.user.service;


import com.moass.api.domain.user.dto.UserSignUpDto;
import com.moass.api.domain.user.entity.User;
import com.moass.api.domain.user.entity.UserDetail;
import com.moass.api.domain.user.repository.SsafyUserRepository;
import com.moass.api.domain.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;

@RequiredArgsConstructor
@Service
public class UserService {

    private final UserRepository userRepository;
    private final SsafyUserRepository ssafyUserRepository;
    private final PasswordEncoder passwordEncoder;



    public Mono<UserDetail> signUp(UserSignUpDto userDto) {
        return userRepository.findByUserEmail(userDto.getUserEmail())
                .flatMap(dbUser -> Mono.<UserDetail>error(new RuntimeException("사용자가 이미 존재합니다.")))
                .switchIfEmpty(
                        ssafyUserRepository.findByUserId(userDto.getUserId())
                                .switchIfEmpty(Mono.error(new RuntimeException("등록되어 있지 않는 사용자입니다.")))
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
}
