package com.moass.api.domain.user.service;


import com.moass.api.domain.user.dto.*;
import com.moass.api.domain.user.entity.*;
import com.moass.api.domain.user.entity.Class;
import com.moass.api.domain.user.repository.*;
import com.moass.api.global.auth.JWTService;
import com.moass.api.global.auth.dto.Tokens;
import com.moass.api.global.auth.dto.UserInfo;
import com.moass.api.global.exception.CustomException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
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

@Slf4j
@RequiredArgsConstructor
@Service
public class UserService {

    private final UserRepository userRepository;
    private final TeamRepository teamRepository;
    private final ClassRepository classRepository;
    private final LocationRepository locationRepository;
    private final CustomUserRepository customUserRepository;

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

    public Mono<TeamInfoDto> getTeamInfo(String teamCode) {
        log.info("Fetching team and users for teamCode: {}", teamCode);
        return customUserRepository.findAllTeamUserByTeamCode(teamCode)
                .map(UserSearchInfoDto::new)
                .collectList()
                .flatMap(userSearchInfoList -> {
                    if (userSearchInfoList.isEmpty()) {
                        return Mono.error(new CustomException("No team found with the given team code.", HttpStatus.NOT_FOUND));
                    }
                    log.info("낫블로킹1");
                    TeamInfoDto teamInfo = new TeamInfoDto();
                    teamInfo.setTeamCode(teamCode);
                    log.info("낫블로킹2");
                    teamInfo.setTeamName(userSearchInfoList.get(0).getTeamName()); // Assuming all entries have the same team name
                    log.info("낫블로킹3");
                    teamInfo.setUsers(userSearchInfoList.stream().collect(Collectors.toList()));
                    log.info("낫블로킹4");
                    return Mono.just(teamInfo);
                });
    }

    /**
    public Mono<TeamInfoDto> getTeamInfo(String teamCode) {
        log.info("Fetching team and users for teamCode: {}", teamCode);

        Mono<TeamLocDetail> d = teamRepository.findTeamLocDetailByTeamCode(teamCode);
        return userRepository.findAllTeamUserByTeamCode(teamCode)
                        .map(ReqFilteredUserDetailDto::new)
                        .collectList()
                        .flatMap(userSearchInfoList -> {
                            if (userSearchInfoList.isEmpty()) {
                                return Mono.error(new CustomException("No team found with the given team code.", HttpStatus.NOT_FOUND));
                            }
                            log.info("낫블로킹1");
                            TeamInfoDto teamInfo = new TeamInfoDto();
                            teamInfo.setTeamCode(teamCode);
                            log.info("낫블로킹2");
                            teamInfo.setTeamName("DD"); // Assuming all entries have the same team name
                            log.info("낫블로킹3");
                            teamInfo.setUsers(userSearchInfoList.stream().collect(Collectors.toList()));
                            log.info("낫블로킹4");
                            log.info("Processing completed for teamCode: {}", teamCode);
                            return Mono.just(teamInfo);
                        });
    }


        return teamRepository.findTeamLocDetailByTeamCode(teamCode)
                .flatMap(teamLocDetail -> userRepository.findAllTeamUserByTeamCode(teamCode)
                        .map(ReqFilteredUserDetailDto::new)
                        .collectList()
                        .flatMap(userSearchInfoList -> {
                            if (userSearchInfoList.isEmpty()) {
                                return Mono.error(new CustomException("No team found with the given team code.", HttpStatus.NOT_FOUND));
                            }
                            log.info("낫블로킹1");
                            TeamInfoDto teamInfo = new TeamInfoDto();
                            teamInfo.setTeamCode(teamCode);
                            log.info("낫블로킹2");
                            teamInfo.setTeamName(teamLocDetail.getTeamName()); // Assuming all entries have the same team name
                            log.info("낫블로킹3");
                            teamInfo.setUsers(userSearchInfoList.stream().collect(Collectors.toList()));
                            log.info("낫블로킹4");
                            log.info("Processing completed for teamCode: {}", teamCode);
                            return Mono.just(teamInfo);
                        }));
    }
*/

    public Mono<ClassInfoDto> getClassInfo(String classCode) {
        log.info("Fetching teams and users for classCode: {}", classCode);
        return classRepository.findAllTeamsAndUsersByClassCode(classCode)
                .map(UserSearchInfoDto::new)  // UserSearchDetail을 UserSearchInfoDto로 변환
                .collectList()
                .flatMap(userSearchInfoList -> {
                    if (userSearchInfoList.isEmpty()) {
                        return Mono.error(new CustomException("해당 반에 대한 정보가 없습니다.", HttpStatus.NOT_FOUND));
                    }
                    ClassInfoDto classInfo = new ClassInfoDto();
                    classInfo.setClassCode(classCode);
                    classInfo.setLocationCode(userSearchInfoList.get(0).getLocationCode());
                    List<TeamInfoDto> teams = userSearchInfoList.stream()
                            .collect(Collectors.groupingBy(UserSearchInfoDto::getTeamCode))
                            .entrySet().stream()
                            .map(entry -> {
                                TeamInfoDto teamInfo = new TeamInfoDto();
                                teamInfo.setTeamCode(entry.getKey());
                                //teamInfo.setUsers(entry.getValue());
                                return teamInfo;
                            }).collect(Collectors.toList());

                    classInfo.setTeams(teams);
                    return Mono.just(classInfo);
                })
                .doOnSuccess(classInfo -> log.info("Completed fetching class info for classCode: {}", classCode));
    }

    public Mono<LocationInfoDto> getLocationInfo(String locationCode) {
        log.info("Fetching classes, teams, and users for locationCode: {}", locationCode);
        return locationRepository.findAllTeamsAndUsersByLocationCode(locationCode)
                .map(UserSearchInfoDto::new)  // UserSearchDetail을 UserSearchInfoDto로 변환
                .collectList()
                .flatMap(userSearchInfoList -> {
                    if (userSearchInfoList.isEmpty()) {
                        return Mono.error(new CustomException("해당 위치에 대한 정보가 없습니다.", HttpStatus.NOT_FOUND));
                    }
                    LocationInfoDto locationInfo = new LocationInfoDto();
                    locationInfo.setLocationCode(locationCode);
                    locationInfo.setLocationName(userSearchInfoList.get(0).getLocationName());  // 가정: 모든 항목이 같은 위치 이름을 가집니다.
                    locationInfo.setClasses(
                            userSearchInfoList.stream()
                                    .collect(Collectors.groupingBy(UserSearchInfoDto::getClassCode))
                                    .entrySet().stream()
                                    .map(entry -> {
                                        ClassInfoDto classInfo = new ClassInfoDto();
                                        classInfo.setClassCode(entry.getKey());
                                        classInfo.setTeams(
                                                entry.getValue().stream()
                                                        .collect(Collectors.groupingBy(UserSearchInfoDto::getTeamCode))
                                                        .entrySet().stream()
                                                        .map(teamEntry -> {
                                                            TeamInfoDto teamInfo = new TeamInfoDto();
                                                            teamInfo.setTeamCode(teamEntry.getKey());
                                                            //teamInfo.setUsers(teamEntry.getValue());
                                                            return teamInfo;
                                                        }).collect(Collectors.toList())
                                        );
                                        return classInfo;
                                    }).collect(Collectors.toList())
                    );
                    return Mono.just(locationInfo);
                })
                .doOnSuccess(locationInfo -> log.info("Completed fetching location info for locationCode: {}", locationCode));
    }



    /**
    public Mono<TeamInfoDto> getTeamInfo(String teamCode) {
        log.info("팀 검색: {}", teamCode);
        return teamRepository.findByTeamCode(teamCode)
                .flatMap(team -> userRepository.findAllTeamUserByTeamCode(team.getTeamCode())
                        .collectList()
                        .flatMap(userDetails -> {
                            TeamInfoDto teamInfo = new TeamInfoDto();
                            teamInfo.setTeamCode(team.getTeamCode());
                            teamInfo.setTeamName(team.getTeamName());
                            teamInfo.setUsers(userDetails.stream().map(ReqFilteredUserDetailDto::new).collect(Collectors.toList()));
                            return Mono.just(teamInfo);
                        }));
    }

    public Mono<ClassInfoDto> getClassInfo(String classCode) {
        log.info("Fetching teams for classCode: {}", classCode);
        return teamRepository.findAllTeamByClassCode(classCode)
                .flatMap(team -> getTeamInfo(team.getTeamCode())
                        .doOnSuccess(teamInfo -> log.info("Retrieved team info for teamCode: {}", teamInfo.getTeamCode()))
                )
                .collectList()  // 모든 팀 정보를 리스트로 수집
                .flatMap(teamInfos -> {
                    if (teamInfos.isEmpty()) {
                        return Mono.error(new CustomException("해당 클래스에 팀이 없습니다.", HttpStatus.NOT_FOUND));
                    }
                    ClassInfoDto classInfo = new ClassInfoDto();
                    classInfo.setClassCode(classCode);
                    classInfo.setTeams(teamInfos);  // 팀 정보 리스트를 설정
                    return Mono.just(classInfo);
                })
                .doOnSuccess(classInfo -> log.info("Completed fetching class info for classCode: {}", classCode));
    }




    public Mono<LocationInfoDto> getLocationInfo(String locationCode) {
        log.info("Fetching classes for locationCode: {}", locationCode);
        return classRepository.findAllClassByLocationCode(locationCode)
                .flatMap(classInfo -> getClassInfo(classInfo.getClassCode()))
                .collectList()  // 모든 클래스 정보를 리스트로 수집
                .flatMap(classInfos -> {
                    if (classInfos.isEmpty()) {
                        return Mono.error(new CustomException("해당 위치에 클래스가 없습니다.", HttpStatus.NOT_FOUND));
                    }
                    return locationRepository.findByLocationCode(locationCode)
                            .flatMap(location -> {
                                LocationInfoDto locationInfo = new LocationInfoDto();
                                locationInfo.setLocationCode(locationCode);
                                locationInfo.setLocationName(location.getLocationName());  // 위치 이름 설정
                                locationInfo.setClasses(classInfos);
                                return Mono.just(locationInfo);
                            });
                })
                .doOnSuccess(locationInfo -> log.info("Completed fetching location info for locationCode: {}", locationCode));
    }

     */


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
