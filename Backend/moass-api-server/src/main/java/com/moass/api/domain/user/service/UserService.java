package com.moass.api.domain.user.service;


import com.moass.api.domain.user.dto.*;
import com.moass.api.domain.user.entity.*;
import com.moass.api.domain.user.entity.Class;
import com.moass.api.domain.user.repository.*;
import com.moass.api.global.auth.JWTService;
import com.moass.api.global.auth.dto.Tokens;
import com.moass.api.global.auth.dto.UserInfo;
import com.moass.api.global.config.S3ClientConfigurationProperties;
import com.moass.api.global.exception.CustomException;
import com.moass.api.global.service.S3Service;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.nio.ByteBuffer;
import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@RequiredArgsConstructor
@Service
public class UserService {

    private final UserRepository userRepository;
    private final TeamRepository teamRepository;
    private final ClassRepository classRepository;
    private final LocationRepository locationRepository;
    private final CustomUserRepository customUserRepository;
    private final S3ClientConfigurationProperties s3config;
    private final WidgetRepository widgetRepository;

    private final SsafyUserRepository ssafyUserRepository;
    private final PasswordEncoder passwordEncoder;
    private final JWTService jwtService;
    private final S3Service s3Service;
    public Mono<UserDetail> signUp(UserSignUpDto userDto) {
        return userRepository.findByUserEmailOrUserId(userDto.getUserEmail(), userDto.getUserId()).flatMap(dbUser -> Mono.<UserDetail>error(new CustomException("사용자가 이미 존재합니다.", HttpStatus.CONFLICT))).switchIfEmpty(ssafyUserRepository.findByUserId(userDto.getUserId()).switchIfEmpty(Mono.error(new CustomException("등록되어 있지 않는 사용자입니다.", HttpStatus.BAD_REQUEST))).flatMap(ssafyUser -> {
            User newUser = User.builder().userId(ssafyUser.getUserId()).userEmail(userDto.getUserEmail()).password(passwordEncoder.encode(userDto.getPassword())).build();
            return userRepository.saveForce(newUser).thenReturn(new UserDetail(newUser, ssafyUser));
        }));
    }


    public Mono<Tokens> refreshAccessToken(String refreshToken) {
        return Mono.defer(() -> {
            if (!jwtService.validateRefreshToken(refreshToken)) {
                return Mono.error(new CustomException("유효하지 않거나 만료된 토큰입니다.", HttpStatus.UNAUTHORIZED));
            }
            return Mono.just(refreshToken);
        }).flatMap(token -> Mono.justOrEmpty(jwtService.getUserInfoFromRefreshToken(token))).flatMap(userInfo -> {
            if (userInfo == null || userInfo.getUserEmail().isEmpty()) {
                return Mono.error(new CustomException("토큰의 이메일이 유효하지 않습니다.", HttpStatus.BAD_GATEWAY));
            }
            return jwtService.generateTokens(userInfo);
        });
    }


    public Mono<UserSearchInfoDto> getUserDetail(String userEmail) {
        return userRepository.findByUserEmail(userEmail)
                .switchIfEmpty(Mono.error(new CustomException("존재하지 않는 사용자입니다.", HttpStatus.NOT_FOUND)))
                .flatMap(team -> userRepository.findUserSearchDetailByUserEmail(userEmail)
                        .switchIfEmpty(Mono.error(new CustomException("사용자가 존재하지 않습니다.", HttpStatus.NOT_FOUND)))
                        .flatMap(userSearchDetail -> Mono.just(new UserSearchInfoDto(userSearchDetail))));
    }

    /**
     * Todo
     * 복잡도 해결
     *
     * @param userInfo
     * @param userUpdateDto
     * @return
     */
    @Transactional
    public Mono<Boolean> userUpdate(UserInfo userInfo, UserUpdateDto userUpdateDto) {
        return Mono.zip(userProfileUpdate(userInfo, userUpdateDto),
                        teamNameUpdate(userInfo, userUpdateDto),
                        (profileUpdated, teamUpdated) -> profileUpdated || teamUpdated)
                .doOnSuccess(result -> log.info("result: {}", result))
                .flatMap(result -> (result ? Mono.just(true): Mono.error(new CustomException("변경된 사항이 없습니다.", HttpStatus.BAD_REQUEST))));
    }

    public Mono<Boolean> userProfileUpdate(UserInfo userInfo, UserUpdateDto userUpdateDto){
        return userRepository.findByUserId(userInfo.getUserId()).flatMap(user -> {
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
            if (userUpdateDto.getLayout() != null && !userUpdateDto.getLayout().equals(user.getLayout())) {
                user.setLayout(userUpdateDto.getLayout());
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
            log.info("isUpdated: {}", isUpdated);
            return (isUpdated ? userRepository.save(user).thenReturn(true) : Mono.just(false));
        }).switchIfEmpty(Mono.error(new CustomException("사용자가 존재하지 않습니다.", HttpStatus.NOT_FOUND)));
    }

    public Mono<Boolean> teamNameUpdate(UserInfo userInfo, UserUpdateDto userUpdateDto){
        return teamRepository.findByUserId(userInfo.getUserId()).flatMap(team -> {
            boolean isUpdated = false;
            if (userUpdateDto.getTeamName() != null && !userUpdateDto.getTeamName().equals(team.getTeamName())) {
                team.setTeamName(userUpdateDto.getTeamName());
                isUpdated = true;
            }
            log.info("isUpdated: {}", isUpdated);
            return (isUpdated ? teamRepository.save(team).thenReturn(true) : Mono.just(false));
        }).switchIfEmpty(Mono.error(new CustomException("팀이 존재하지 않습니다.", HttpStatus.NOT_FOUND)));
    }


    public Mono<List<UserSearchInfoDto>> findByUsername(UserInfo userInfo, String userName) {
        return ssafyUserRepository.exisisByUserName(userName, userInfo.getJobCode())
                .switchIfEmpty(Mono.error(new CustomException("사용자가 존재하지 않습니다.", HttpStatus.NOT_FOUND)))
                .flatMap(userExist -> ssafyUserRepository.findAllUserSearchDetailByuserName(userName, userInfo.getJobCode()).collectList().flatMap(userSearchDetails -> {
            if (userSearchDetails.isEmpty()) {
                return Mono.error(new CustomException("사용자가 존재하지 않습니다.", HttpStatus.NOT_FOUND));
            }
            return Mono.just(userSearchDetails.stream().map(UserSearchInfoDto::new).toList());
        }));
    }

    public Mono<TeamInfoDto> getTeamInfo(String teamCode) {
        return teamRepository.findByTeamCode(teamCode)
                .switchIfEmpty(Mono.error(new CustomException("존재하지 않는 팀입니다.", HttpStatus.NOT_FOUND)))
                .flatMap(teamExist -> teamRepository.findTeamUserByTeamCode(teamCode)
                        .map(UserSearchInfoDto::new).collectList().flatMap(userSearchInfoList -> {
                            if (userSearchInfoList.isEmpty()) {
                                return Mono.empty();
                            }
                            TeamInfoDto teamInfo = new TeamInfoDto();
                            teamInfo.setTeamCode(teamCode);
                            teamInfo.setTeamName(userSearchInfoList.get(0).getTeamName()); // 모든 항목이 같은 팀 이름을 가정
                            teamInfo.setUsers(userSearchInfoList);
                            return Mono.just(teamInfo);
                        }));
    }

    public Mono<ClassInfoDto> getClassInfo(String classCode) {
        return classRepository.findByClassCode(classCode)
                .switchIfEmpty(Mono.error(new CustomException("존재하지 않는 반입니다.", HttpStatus.NOT_FOUND)))
                .flatMap(classExist -> classRepository.findAllTeamsAndUsersByClassCode(classCode)
                        .map(UserSearchInfoDto::new)
                        .collectList()
                        .flatMap(userSearchInfoList -> {
                            if (userSearchInfoList.isEmpty()) {
                                return Mono.error(new CustomException("해당반에 팀이 없습니다.", HttpStatus.NOT_FOUND));
                            }
                            ClassInfoDto classInfo = new ClassInfoDto();
                            classInfo.setClassCode(classCode);
                            classInfo.setLocationCode(userSearchInfoList.get(0).getLocationCode());
                            List<TeamInfoDto> teams = userSearchInfoList.stream().collect(
                                            Collectors.groupingBy(UserSearchInfoDto::getTeamCode))
                                    .entrySet().stream().map(entry -> {
                                        TeamInfoDto teamInfo = new TeamInfoDto();
                                        teamInfo.setTeamCode(entry.getKey());
                                        teamInfo.setUsers(entry.getValue());
                                        return teamInfo;
                                    })
                                    .collect(Collectors.toList());
                            classInfo.setTeams(teams);
                            return Mono.just(classInfo);
                        }));
    }

    public Mono<LocationInfoDto> getLocationInfo(String locationCode) {
        return locationRepository.findByLocationCode(locationCode)
                .switchIfEmpty(Mono.error(new CustomException("존재하지 않는 지역입니다.", HttpStatus.NOT_FOUND)))
                .flatMap(location ->
                        locationRepository.findAllTeamsAndUsersByLocationCode(locationCode)
                                .map(UserSearchInfoDto::new)
                                .collectList()
                                .flatMap(userSearchInfoList -> {
                                    if (userSearchInfoList.isEmpty()) {
                                        return Mono.error(new CustomException("해당 지역에 사람이 없습니다.", HttpStatus.NOT_FOUND));
                                    }
                                    LocationInfoDto locationInfo = new LocationInfoDto();
                                    locationInfo.setLocationCode(locationCode);
                                    locationInfo.setLocationName(userSearchInfoList.get(0).getLocationName());
                                    locationInfo.setClasses(
                                            userSearchInfoList.stream()
                                                    .collect(Collectors.groupingBy(UserSearchInfoDto::getClassCode))
                                                    .entrySet().stream()
                                                    .map(classEntry -> {
                                                        ClassInfoDto classInfo = new ClassInfoDto();
                                                        classInfo.setClassCode(classEntry.getKey());
                                                        classInfo.setLocationCode(locationCode);
                                                        classInfo.setTeams(
                                                                classEntry.getValue().stream()
                                                                        .collect(Collectors.groupingBy(UserSearchInfoDto::getTeamCode))
                                                                        .entrySet().stream()
                                                                        .map(teamEntry -> {
                                                                            TeamInfoDto teamInfo = new TeamInfoDto();
                                                                            teamInfo.setTeamCode(teamEntry.getKey());
                                                                            teamInfo.setTeamName(teamEntry.getValue().get(0).getTeamName()); // 모든 항목이 같은 팀 이름을 가정
                                                                            teamInfo.setUsers(teamEntry.getValue());
                                                                            return teamInfo;
                                                                        }).collect(Collectors.toList())
                                                        );
                                                        return classInfo;
                                                    }).collect(Collectors.toList())
                                    );
                                    return Mono.just(locationInfo);
                                })
                );
    }

    public Mono<Object> createUser(UserInfo userInfo, UserCreateDto userCreateDto) {
        // 문법오류 해결
        return ssafyUserRepository.findByUserId(userCreateDto.getUserId())
                .flatMap(existingUser -> Mono.error(new CustomException("이미 존재하는 사용자입니다.", HttpStatus.CONFLICT)))
                        .switchIfEmpty(Mono.defer(() -> {
                            SsafyUser newSsafyUser = new SsafyUser(userCreateDto);
                            return ssafyUserRepository.saveForce(newSsafyUser)
                                    .then(Mono.just(newSsafyUser));
                        }));
    }

    public Mono<String> profileImgUpload(UserInfo userInfo, HttpHeaders headers, Flux<ByteBuffer> file) {
        return s3Service.uploadHandler(headers, file)
                .flatMap(uploadResult -> {
                    if (uploadResult.getStatus() != HttpStatus.CREATED) {
                        return Mono.error(new CustomException("Image upload failed", HttpStatus.INTERNAL_SERVER_ERROR));
                    }
                    String fileKey = uploadResult.getKeys()[0];
                    return userRepository.findByUserId(userInfo.getUserId())
                            .flatMap(user -> {
                                user.setProfileImg(s3config.getImageUrl()+"/"+fileKey);
                                return userRepository.save(user).thenReturn(s3config.getImageUrl() + "/" + fileKey);
                            });
                });
    }

    public Mono<String> backgroundImgUpload(UserInfo userInfo, HttpHeaders headers, Flux<ByteBuffer> file) {
        return s3Service.uploadHandler(headers, file)
                .flatMap(uploadResult -> {
                    if (uploadResult.getStatus() != HttpStatus.CREATED) {
                        return Mono.error(new CustomException("Image upload failed", HttpStatus.INTERNAL_SERVER_ERROR));
                    }
                    String fileKey = uploadResult.getKeys()[0];
                    return userRepository.findByUserId(userInfo.getUserId())
                            .flatMap(user -> {
                                user.setBackgroundImg(s3config.getImageUrl()+"/"+fileKey);
                                return userRepository.save(user).thenReturn(s3config.getImageUrl() + "/" + fileKey);
                            });
                });
    }

    public Mono<String> WidgetImgUpload(UserInfo userInfo, HttpHeaders headers, Flux<ByteBuffer> file) {
        return s3Service.uploadHandler(headers, file)
                .flatMap(uploadResult -> {
                    if (uploadResult.getStatus() != HttpStatus.CREATED) {
                        return Mono.error(new CustomException("Image upload failed", HttpStatus.INTERNAL_SERVER_ERROR));
                    }
                    String fileKey = uploadResult.getKeys()[0];
                    return widgetRepository.save(Widget.builder()
                                    .userId(userInfo.getUserId())
                                    .widgetImg(s3config.getImageUrl() + "/" + fileKey)
                                    .build())
                            .thenReturn(s3config.getImageUrl() + "/" + fileKey);
                });
    }

    public Mono<List<WidgetDetailDto>> getWidgetImg(UserInfo userInfo) {
        return widgetRepository.findAllByUserId(userInfo.getUserId())
                .collectList()
                .map(widgets -> widgets.stream().map(WidgetDetailDto::new).toList())
                .switchIfEmpty(Mono.error(new CustomException("위젯을 찾을 수 없습니다.", HttpStatus.NOT_FOUND)));
    }

    public Mono<WidgetDetailDto> deleteWidgetImg(UserInfo userInfo, String widgetId) {
        return widgetRepository.findByWidgetIdAndUserId(widgetId, userInfo.getUserId())
                .switchIfEmpty(Mono.error(new CustomException("위젯을 찾을 수 없습니다.", HttpStatus.NOT_FOUND)))
                .flatMap(widget -> widgetRepository.delete(widget)
                        .thenReturn(widget)
                        .map(deletedWidget -> new WidgetDetailDto(deletedWidget)));
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
