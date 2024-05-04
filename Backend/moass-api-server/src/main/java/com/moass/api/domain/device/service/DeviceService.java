package com.moass.api.domain.device.service;


import com.moass.api.domain.device.dto.DeviceIdDto;
import com.moass.api.domain.device.dto.ReqDeviceLoginDto;
import com.moass.api.domain.device.dto.ReqDeviceLogoutDto;
import com.moass.api.domain.device.repository.DeviceRepository;
import com.moass.api.domain.user.dto.ReqFilteredUserDetailDto;
import com.moass.api.domain.user.dto.UserLoginDto;
import com.moass.api.domain.user.repository.SsafyUserRepository;
import com.moass.api.domain.user.repository.UserRepository;
import com.moass.api.global.auth.CustomReactiveUserDetailsService;
import com.moass.api.global.auth.CustomUserDetails;
import com.moass.api.global.auth.JWTService;
import com.moass.api.global.auth.dto.Tokens;
import com.moass.api.global.auth.dto.UserInfo;
import com.moass.api.global.exception.CustomException;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import reactor.core.publisher.Mono;
import reactor.util.function.Tuples;

@RequiredArgsConstructor
@Service
public class DeviceService {

    private final UserRepository userRepository;
    private final SsafyUserRepository ssafyUserRepository;
    private final DeviceRepository deviceRepository;
    private final CustomReactiveUserDetailsService userDetailsService;
    private final JWTService jwtService;


    @Transactional
    public Mono<Tokens> deviceLogin(ReqDeviceLoginDto reqDeviceLoginDto) {
        return deviceLoginAuth(reqDeviceLoginDto)
                .flatMap(userLoginDto -> updateUserConnectionFlag(userLoginDto.getUserEmail(), 1)
                        .then(userDetailsService.authenticate(userLoginDto.getUserEmail(), userLoginDto.getPassword(), true))
                        .flatMap(auth -> {
                            CustomUserDetails customUserDetails = (CustomUserDetails) auth.getPrincipal();
                            UserInfo userInfo = new UserInfo(customUserDetails.getUserDetail());
                            return jwtService.generateTokens(userInfo);
                        }));
    }

    /**
     * Todo
     * 추후, 연결된 기기(본인이라도)에 로그아웃 하라는 SSE메세지 적용 필요
     * @param
     * @return
     */
    @Transactional
    public Mono<String> deviceLogout(UserInfo userInfo) {
        return updateUserConnectionFlag(userInfo.getUserEmail(), 0) // 로그아웃 전 connectFlag 업데이트
                .then(deviceRepository.findByUserId(userInfo.getUserId()))
                .switchIfEmpty(Mono.error(new CustomException("연결된 기기가 없습니다.", HttpStatus.NOT_FOUND)))
                .flatMap(device -> {
                    device.setUserId(null);
                    return deviceRepository.save(device).then(Mono.just(device.getDeviceId()));
                });
    }

    @Transactional
    public Mono<UserLoginDto> deviceLoginAuth(ReqDeviceLoginDto reqDeviceLoginDto) {
        return ssafyUserRepository.findUserDetailByCardSerialId(reqDeviceLoginDto.getCardSerialId())
                .switchIfEmpty(Mono.error(new CustomException("해당 카드 ID가 시스템에 등록되지 않았습니다. 카드를 다시 확인해 주세요.", HttpStatus.NOT_FOUND)))
                .flatMap(userDetail -> deviceRepository.findByDeviceId(reqDeviceLoginDto.getDeviceId())
                        .switchIfEmpty(Mono.error(new CustomException("해당 기기 ID가 시스템에 등록되지 않았습니다. 기기를 다시 확인해 주세요.", HttpStatus.NOT_FOUND)))
                        .flatMap(device -> {
                            if (device.getUserId() != null && !device.getUserId().equals(userDetail.getUserId())) {
                                return Mono.error(new CustomException("이 기기는 현재 다른 사용자에 의해 사용 중입니다. 기기 ID 또는 사용자 정보를 확인해 주세요.", HttpStatus.FORBIDDEN));
                            }
                            if (device.getUserId() != null && device.getUserId().equals(userDetail.getUserId())) {
                                return Mono.error(new CustomException("이 기기는 이미 해당 사용자에게 등록되어 있습니다.", HttpStatus.BAD_REQUEST));
                            }
                            device.setUserId(userDetail.getUserId());
                            return deviceRepository.save(device)
                                    .map(savedDevice -> new UserLoginDto(userDetail));
                        }));
    }
    public Mono<Void> updateUserConnectionFlag(String userEmail, int flag) {
        return userRepository.findByUserEmail(userEmail)
                .switchIfEmpty(Mono.error(new CustomException("사용자를 찾을 수 없습니다.", HttpStatus.NOT_FOUND)))
                .flatMap(user -> {
                    if(flag==1&&user.getConnectFlag()==1){
                        return Mono.error(new CustomException("이미 연결된 사용자입니다.", HttpStatus.BAD_REQUEST));
                    }else if(flag==0 && user.getConnectFlag()==0){
                        return Mono.error(new CustomException("이미 연결해제된 사용자입니다.", HttpStatus.BAD_REQUEST));
                    }
                    user.setConnectFlag(flag);
                    return userRepository.save(user).then();
                });
    }

    public Mono<Boolean> isLogin(DeviceIdDto deviceIdDto) {
        return deviceRepository.findByDeviceId(deviceIdDto.getDeviceId())
                .switchIfEmpty(Mono.error(new CustomException("디바이스가 시스템에 등록되지 않았습니다.", HttpStatus.NOT_FOUND)))
                .flatMap(device -> deviceRepository.isUserLoggedIn(deviceIdDto.getDeviceId()));
    }
}
