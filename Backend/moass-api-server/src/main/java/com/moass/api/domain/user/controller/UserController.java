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
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Mono;


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

    @GetMapping
    public Mono<ResponseEntity<ApiResponse>> getUserDetails(@Login UserInfo userInfo, @RequestParam(required = false) String username) {
        if(username != null) {
            System.out.println(username);
            return userService.findByUsername(userInfo, username)
                    .flatMap(userDetail -> ApiResponse.ok("사용자 정보 조회 성공", userDetail))
                    .onErrorResume(CustomException.class,e -> ApiResponse.error("사용자 정보 조회 실패: "+e.getMessage(), e.getStatus()));
        }
        else{
            return userService.getUserDetail(userInfo.getUserEmail())
                    .flatMap(reqFilteredUserDetailDto -> ApiResponse.ok("조회완료",reqFilteredUserDetailDto))
                    .onErrorResume(CustomException.class,e -> ApiResponse.error("사용자 정보 조회 실패: "+e.getMessage(), e.getStatus()));
        }
    }

    @GetMapping("/search")
    public Mono<ResponseEntity<ApiResponse>> getTeam(@Login UserInfo userInfo,
                                                     @RequestParam(name = "teamcode", required = false) String teamCode,
                                                     @RequestParam(name = "classcode", required = false) String classCode,
                                                     @RequestParam(name = "locationcode", required = false) String locationCode) {
        log.info("Search request received: teamCode={}, classCode={}, locationCode={}", teamCode, classCode, locationCode);
        int paramCount = 0;
        if (teamCode != null) paramCount++;
        if (classCode != null) paramCount++;
        if (locationCode != null) paramCount++;

        if (paramCount == 1) {  // 하나의 매개변수만 제공된 경우
            if (teamCode != null) {
                // teamCode만 제공된 경우
                return userService.getTeamInfo(teamCode)
                        .flatMap(team -> ApiResponse.ok("조회완료", team))
                        .switchIfEmpty(ApiResponse.ok("팀 조회 실패 : 해당 팀에 팀원이 존재하지 않습니다.", HttpStatus.NOT_FOUND))
                        .onErrorResume(CustomException.class, e -> ApiResponse.error("팀 조회 실패 : " + e.getMessage(), e.getStatus()));
            } else if (classCode != null) {
                // classCode만 제공된 경우
                return userService.getClassInfo(classCode)
                        .flatMap(classInfo -> ApiResponse.ok("조회완료", classInfo))
                        .onErrorResume(CustomException.class, e -> ApiResponse.error("클래스 조회 실패 : " + e.getMessage(), e.getStatus()));
            } else {
                // locationCode만 제공된 경우
                return userService.getLocationInfo(locationCode)
                        .flatMap(locationInfo -> ApiResponse.ok("조회완료", locationInfo))
                        .onErrorResume(CustomException.class, e -> ApiResponse.error("지역 조회 실패 : " + e.getMessage(), e.getStatus()));
            }
        } else {  // 매개변수가 너무 많거나 하나도 없는 경우
            return ApiResponse.error("정확히 하나의 매개변수만 제공해야 합니다.", HttpStatus.BAD_REQUEST);
        }
    }

    @GetMapping("/class")
    public Mono<ResponseEntity<ApiResponse>> getClassInfo(@Login UserInfo userInfo,
                                                          @RequestParam(name = "classcode", required = true) String classCode){
        return userService.getClassInfo(classCode)
                .flatMap(classInfo -> ApiResponse.ok("조회완료",classInfo))
                .onErrorResume(CustomException.class,e -> ApiResponse.error("조회 실패 : "+e.getMessage(), e.getStatus()));
    }

    /**
    @GetMapping("/all")
    public Mono<ResponseEntity<ApiResponse>> getAllUsers(@Login UserInfo userInfo){
        return userService.getAllUsers(userInfo)
                .flatMap(users -> ApiResponse.ok("조회완료",users))
                .onErrorResume(CustomException.class,e -> ApiResponse.error("조회 실패 : "+e.getMessage(), e.getStatus()));
    }
    */
    /**
    @GetMapping("/all")
    public Mono<ResponseEntity<
    /**
    @PostMapping(value = "/profileImg")
    public Mono<ResponseEntity<ApiResponse>> updateProfileImg(@Login UserInfo userInfo, @RequestHeader HttpHeaders headers, @RequestPart("file") Flux<ByteBuffer> file){
        return userService.updateProfileImg(userInfo,headers,file)
                .flatMap(fileName -> ApiResponse.ok("수정완료",fileName))
                .onErrorResume(CustomException.class,e -> ApiResponse.error("수정 실패 : "+e.getMessage(), e.getStatus()));
    }

*/
}
