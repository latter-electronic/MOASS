package com.moass.api.domain.device.service;


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
                .flatMap(userLoginDto -> userDetailsService.authenticate(userLoginDto.getUserEmail(),userLoginDto.getPassword(),true)
                        .flatMap(auth -> {
                            CustomUserDetails customUserDetails = (CustomUserDetails) auth.getPrincipal();
                            UserInfo userInfo = new UserInfo(customUserDetails.getUserDetail());
                            return jwtService.generateTokens(userInfo);
                        })
                );
    }

    /**
     * Todo
     * 추후, 연결된 기기(본인이라도)에 로그아웃 하라는 SSE메세지 적용 필요
     * @param
     * @return
     */
    @Transactional
    public Mono<Void> deviceLogout(UserInfo userInfo) {
        return deviceRepository.findByUserId(userInfo.getUserId())
                .switchIfEmpty(Mono.error(new CustomException("연결된 기기가 없습니다.", HttpStatus.NOT_FOUND)))
                .flatMap(device -> {
                        device.setUserId(null); // 사용자 ID를 null로 설정
                        return deviceRepository.save(device).then(); // 변경사항 저장 후 완료 신호만 보냄

                });
    }

    public Mono<UserLoginDto> deviceLoginAuth(ReqDeviceLoginDto reqDeviceLoginDto) {
        return ssafyUserRepository.findUserDetailByCardSerialId(reqDeviceLoginDto.getCardSerialId())
                .switchIfEmpty(Mono.error(new CustomException("등록되지 않은 카드입니다.", HttpStatus.NOT_FOUND)))
                .flatMap(userDetail -> deviceRepository.findByDeviceId(reqDeviceLoginDto.getDeviceId())
                        .switchIfEmpty(Mono.error(new CustomException("등록되지 않은 기기입니다.", HttpStatus.NOT_FOUND)))
                        .flatMap(device -> {
                            if(device.getUserId() == null){
                                device.setUserId(userDetail.getUserId());
                                return deviceRepository.save(device)
                                        .map(savedDevice -> new UserLoginDto(userDetail));
                            }
                            return Mono.error(new CustomException("디바이스가 일치하지 않습니다.", HttpStatus.BAD_REQUEST));

                        }));
    }

}
