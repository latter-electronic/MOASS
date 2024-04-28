package com.moass.api.domain.user.controller;

import com.moass.api.domain.user.dto.UserLoginDto;
import com.moass.api.domain.user.dto.UserSignUpDto;
import com.moass.api.domain.user.dto.UserUpdateDto;
import com.moass.api.domain.user.service.UserService;
import com.moass.api.global.annotaion.Login;
import com.moass.api.global.auth.AuthManager;
import com.moass.api.global.auth.CustomReactiveUserDetailsService;
import com.moass.api.global.auth.CustomUserDetails;
import com.moass.api.global.auth.JWTService;
import com.moass.api.global.auth.dto.UserInfo;
import com.moass.api.global.exception.CustomException;
import com.moass.api.global.response.ApiResponse;
import com.moass.api.global.sse.service.SseService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.http.codec.multipart.FilePart;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.nio.ByteBuffer;

@Slf4j
@RestController
@RequestMapping("/user")
@RequiredArgsConstructor
public class UserController {
    private final CustomReactiveUserDetailsService userDetailsService;

    final UserService userService;
    final SseService sseService;
    final JWTService jwtService;
    final PasswordEncoder encoder;
    final AuthManager authManager;
    @GetMapping("/auth")
    public Mono<String> auth(){
        return Mono.just("t");
    }


    @PostMapping("/login")
    public Mono<ResponseEntity<ApiResponse>> login(@RequestBody UserLoginDto loginDto) {
        return userDetailsService.authenticate(loginDto.getUserEmail(), loginDto.getPassword(),false)
                .flatMap(auth -> {
                    CustomUserDetails customUserDetails = (CustomUserDetails) auth.getPrincipal();
                    UserInfo userInfo = new UserInfo(customUserDetails.getUserDetail());
                    sseService.notifyTeam(userInfo.getTeamCode(),"로그인성공 :"+userInfo.getUserName());
                    sseService.notifyUser(userInfo.getUserId(),"로그인성공 :"+userInfo.getUserName());
                    return jwtService.generateTokens(userInfo);
                })
                .flatMap(tokens -> ApiResponse.ok("로그인 성공", tokens))

                .onErrorResume(CustomException.class, e -> ApiResponse.error("로그인 실패 : " + e.getMessage(), e.getStatus()));
    }

    @PostMapping("/signup")
    public Mono<ResponseEntity<ApiResponse>> signup(@RequestBody UserSignUpDto signUpDto){
        return userService.signUp(signUpDto)
                .flatMap(user -> ApiResponse.ok("회원가입 성공"))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("회원가입 실패: "+e.getMessage(),e.getStatus()));
    }

    @GetMapping("/refresh")
    public Mono<ResponseEntity<ApiResponse>> refreshToken(@RequestHeader("Authorization") String authHeader){
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            return ApiResponse.error("토큰이 제공되지 않았거나 형식이 올바르지 않습니다.", HttpStatus.BAD_REQUEST); // 400 Bad Request
        }

        String refreshToken = authHeader.substring(7);
        return userService.refreshAccessToken(refreshToken)
                .flatMap(tokens -> ApiResponse.ok("토큰이 정상적으로 갱신되었습니다.", tokens))
                .onErrorResume(CustomException.class,e -> ApiResponse.error("갱신 실패 : ", e.getStatus()));
    }

    @GetMapping
    public Mono<ResponseEntity<ApiResponse>> userDetailData(@Login UserInfo userInfo){
        return userService.getUserDetail(userInfo.getUserEmail())
                .flatMap(reqFilteredUserDetailDto -> ApiResponse.ok("조회완료",reqFilteredUserDetailDto))
                .onErrorResume(CustomException.class,e -> ApiResponse.error("갱신 실패 : "+e.getMessage(), e.getStatus()));
    }

    /**
     * Todo
     * SSE
     * @param userInfo
     * @param userUpdateDto
     * @return
     */
    @PatchMapping("/status")
    public Mono<ResponseEntity<ApiResponse>> changeUserStatus(@Login UserInfo userInfo, @RequestBody UserUpdateDto userUpdateDto){
        return userService.UserUpdate(userInfo,userUpdateDto)
                .flatMap(reqFilteredUserDetailDto -> ApiResponse.ok("수정완료",reqFilteredUserDetailDto))
                .onErrorResume(CustomException.class,e -> ApiResponse.error("수정 실패 : "+e.getMessage(), e.getStatus()));
    }

    @GetMapping("/team")
    public Mono<ResponseEntity<ApiResponse>> getTeam(@Login UserInfo userInfo){
        return userService.getTeam(userInfo)
                .flatMap(team -> ApiResponse.ok("조회완료",team))
                .onErrorResume(CustomException.class,e -> ApiResponse.error("조회 실패 : "+e.getMessage(), e.getStatus()));
    }

    /**
    @PostMapping(value = "/profileImg")
    public Mono<ResponseEntity<ApiResponse>> updateProfileImg(@Login UserInfo userInfo, @RequestHeader HttpHeaders headers, @RequestPart("file") Flux<ByteBuffer> file){
        return userService.updateProfileImg(userInfo,headers,file)
                .flatMap(fileName -> ApiResponse.ok("수정완료",fileName))
                .onErrorResume(CustomException.class,e -> ApiResponse.error("수정 실패 : "+e.getMessage(), e.getStatus()));
    }

*/
}
