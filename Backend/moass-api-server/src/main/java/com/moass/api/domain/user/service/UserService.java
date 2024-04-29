package com.moass.api.domain.user.service;


import com.moass.api.domain.user.dto.ReqFilteredUserDetailDto;
import com.moass.api.domain.user.dto.UserSignUpDto;
import com.moass.api.domain.user.dto.UserUpdateDto;
import com.moass.api.domain.user.entity.User;
import com.moass.api.domain.user.entity.UserDetail;
import com.moass.api.domain.user.repository.*;
import com.moass.api.global.auth.JWTService;
import com.moass.api.global.auth.dto.Tokens;
import com.moass.api.global.auth.dto.UserInfo;
import com.moass.api.global.exception.CustomException;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.nio.ByteBuffer;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RequiredArgsConstructor
@Service
public class UserService {

    private final UserRepository userRepository;
    private final TeamRepository teamRepository;
    private final ClassRepository classRepository;
    private final LocationRepository locationRepository;

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
                                            .thenReturn(new UserDetail(newUser, ssafyUser));
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

    /**
     * Todo
     * 복잡도 해결
     * @param userInfo
     * @param userUpdateDto
     * @return
     */
    public Mono<ReqFilteredUserDetailDto> UserUpdate(UserInfo userInfo, UserUpdateDto userUpdateDto) {
        return userRepository.findByUserId(userInfo.getUserId())
                .flatMap(user -> {
                    boolean isUpdated = false;

                    if (userUpdateDto.getUserEmail() != null && !userUpdateDto.getUserEmail().equals(user.getUserEmail())) {
                        user.setUserEmail(userUpdateDto.getUserEmail());
                        isUpdated = true;
                    }
                    if (userUpdateDto.getPassword() != null && !passwordEncoder.matches(userUpdateDto.getPassword(), user.getPassword())) {
                        user.setPassword(passwordEncoder.encode(userUpdateDto.getPassword()));
                        isUpdated = true;
                    }
                    if (userUpdateDto.getStatusId() != null && !userUpdateDto.getStatusId().equals(user.getStatusId())) {
                        user.setStatusId(userUpdateDto.getStatusId());
                        isUpdated = true;
                    }
                    if (userUpdateDto.getProfileImg() != null && !userUpdateDto.getProfileImg().equals(user.getProfileImg())) {
                        user.setProfileImg(userUpdateDto.getProfileImg());
                        isUpdated = true;
                    }
                    if (userUpdateDto.getBackgroundImg() != null && !userUpdateDto.getBackgroundImg().equals(user.getBackgroundImg())) {
                        user.setBackgroundImg(userUpdateDto.getBackgroundImg());
                        isUpdated = true;
                    }
                    // 추가 필드 업데이트
                    if (userUpdateDto.getRayout() != null && !userUpdateDto.getRayout().equals(user.getLayout())) {
                        user.setLayout(userUpdateDto.getRayout());
                        isUpdated = true;
                    }
                    if (userUpdateDto.getConnectFlag() != null && !userUpdateDto.getConnectFlag().equals(user.getConnectFlag())) {
                        user.setConnectFlag(userUpdateDto.getConnectFlag());
                        isUpdated = true;
                    }
                    if (userUpdateDto.getPositionName() != null && !userUpdateDto.getPositionName().equals(user.getPositionName())) {
                        user.setPositionName(userUpdateDto.getPositionName());
                        isUpdated = true;
                    }

                    if (isUpdated) {
                        return userRepository.save(user)
                                .flatMap(saveUser -> getUserDetail(saveUser.getUserEmail()));
                    } else {
                        return Mono.error(new CustomException("변경된 사항이 없습니다.", HttpStatus.BAD_REQUEST));
                    }
                })
                .switchIfEmpty(Mono.error(new CustomException("사용자가 존재하지 않습니다.", HttpStatus.NOT_FOUND)));
    }

    public Mono<List<ReqFilteredUserDetailDto>> getTeam(UserInfo userInfo) {
        return userRepository.findAllTeamUserByTeamCode(userInfo.getTeamCode())
                .collectList()
                .flatMap(userDetail -> {
                    if (userDetail.isEmpty()) {
                        return Mono.error(new CustomException("팀원을 찾을 수 없습니다.", HttpStatus.NOT_FOUND));
                    }
                    return Mono.just(userDetail.stream().map(ReqFilteredUserDetailDto::new).toList());
                });
    }

    public Mono<List<ReqFilteredUserDetailDto>> getTeam(UserInfo userInfo,String teamCode) {
        return userRepository.findAllTeamUserByTeamCode(teamCode)
                .collectList()
                .flatMap(userDetail -> {
                    if (userDetail.isEmpty()) {
                        return Mono.error(new CustomException("팀원을 찾을 수 없습니다.", HttpStatus.NOT_FOUND));
                    }
                    return Mono.just(userDetail.stream().map(ReqFilteredUserDetailDto::new).toList());
                });
    }

    public Mono<List<ReqFilteredUserDetailDto>> findByUsername(UserInfo userInfo,String username) {
        return ssafyUserRepository.findAllUserDetailByuserName(username,userInfo.getJobCode())
                .collectList()
                .flatMap(userDetails -> {
                    if (userDetails.isEmpty()) {
                        return Mono.error(new CustomException("사용자가 존재하지 않습니다.", HttpStatus.NOT_FOUND));
                    }
                    return Mono.just(userDetails.stream().map(ReqFilteredUserDetailDto::new).toList());
                });
    }

    public Mono<Map<String,Map<String,Object>>> getClassInfo(String classCode) {
        return teamRepository.findAllTeamByclassCode(classCode)
                .flatMap(team -> userRepository.findAllTeamUserByTeamCode(team.getTeamCode())
                        .collectList()
                        .map(userDetails -> {
                            Map<String, Object> teamInfo = new HashMap<>();
                            teamInfo.put("팀명", team.getTeamName());
                            teamInfo.put("users", userDetails.stream().map(ReqFilteredUserDetailDto::new).collect(Collectors.toList()));
                            return Map.entry(team.getTeamCode(), teamInfo);
                        }))
                .collectMap(Map.Entry::getKey, Map.Entry::getValue);
    }

    /**
    public Mono<Object> getAllUsers(UserInfo userInfo) {
        return ssafyUserRepository.findAll
    }

     */



    /**
     *
    public Mono<Object> updateProfileImg(UserInfo userInfo, HttpHeaders headers, Flux<ByteBuffer> file) {
        return s3ImageUploader.uploadImage(headers,file)
                .flatMap(fileName -> userRepository.findByUserId(userInfo.getUserId())
                        .flatMap(user -> {
                            user.setProfileImg(fileName);
                            return userRepository.save(user);
                        })
                        .map(user -> fileName));

    }

     */
}
