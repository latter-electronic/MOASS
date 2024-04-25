package com.moass.api.domain.device.service;


import com.moass.api.domain.device.dto.ReqDeviceLoginDto;
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
     * 먼저, serialCardId로, User를 찾는다. - > User가 없으면 에러
     * User가 있으면, Device를 찾는다. -> Device가 없으면 에러
     * Device가 있으면, Device의 serialCardId와 serialCardId가 같은지 확인한다. -> 다르면 에러
     * @param reqDeviceLoginDto
     * @return
     */
    public Mono<UserLoginDto> deviceLoginAuth(ReqDeviceLoginDto reqDeviceLoginDto) {
        return ssafyUserRepository.findUserDetailByCardSerialId(reqDeviceLoginDto.getCardSerialId())
                .switchIfEmpty(Mono.error(new CustomException("등록되지 않은 카드입니다.", HttpStatus.NOT_FOUND)))
                .flatMap(userDetail -> deviceRepository.findByDeviceId(reqDeviceLoginDto.getDeviceId())
                        .switchIfEmpty(Mono.error(new CustomException("등록되지 않은 기기입니다.", HttpStatus.NOT_FOUND)))
                        .flatMap(device -> {
                            if(device.getUserId() == null){
                                return Mono.just(new UserLoginDto(userDetail));
                            }
                            return Mono.error(new CustomException("디바이스가 일치하지 않습니다.", HttpStatus.BAD_REQUEST));

                        }));
    }
}
