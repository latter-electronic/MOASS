package com.moass.api.domain.user.controller;

import com.moass.api.domain.notification.dto.NotificationSendDto;
import com.moass.api.domain.notification.service.NotificationService;
import com.moass.api.domain.user.dto.*;
import com.moass.api.domain.user.service.UserService;
import com.moass.api.global.annotaion.Login;
import com.moass.api.global.auth.AuthManager;
import com.moass.api.global.auth.CustomReactiveUserDetailsService;
import com.moass.api.global.auth.CustomUserDetails;
import com.moass.api.global.auth.JWTService;
import com.moass.api.global.auth.dto.UserInfo;
import com.moass.api.global.exception.CustomException;
import com.moass.api.global.fcm.dto.FcmTokenSaveDto;
import com.moass.api.global.fcm.service.FcmService;
import com.moass.api.global.response.ApiResponse;
import com.moass.api.global.sse.dto.SseNotificationDto;
import com.moass.api.global.sse.dto.SseOrderDto;
import com.moass.api.global.sse.dto.SseUpdateDto;
import com.moass.api.global.sse.service.SseService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
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
    final FcmService fcmService;
    final JWTService jwtService;
    final PasswordEncoder encoder;
    final AuthManager authManager;
    final NotificationService notificationService;

    @GetMapping("/auth")
    public Mono<String> auth(){
        return Mono.just("t");
    }


    @PostMapping("/login")
    public Mono<ResponseEntity<ApiResponse>> login(@RequestBody UserLoginDto loginDto) {
        return userDetailsService.authenticate(loginDto.getUserEmail(), loginDto.getPassword(), false)
                .flatMap(auth -> {
                    CustomUserDetails customUserDetails = (CustomUserDetails) auth.getPrincipal();
                    UserInfo userInfo = new UserInfo(customUserDetails.getUserDetail());
                    Mono<Integer> teamNoty = notificationService.saveAndPushbyTeam(userInfo.getTeamCode(),new NotificationSendDto("server","팀원 로그인 알림 : "+userInfo.getUserName(),userInfo.getUserName()+"님이 로그인하셨습니다."));

                    return Mono.when(teamNoty)
                                    .then(jwtService.generateTokens(userInfo));
                })
                .flatMap(tokens -> ApiResponse.ok("로그인 성공", tokens))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("로그인 실패 : " + e.getMessage(), e.getStatus()));
    }

    @PostMapping("/devicelogout")
    public Mono<ResponseEntity<ApiResponse>> deviceLogout(@Login UserInfo userInfo){
        return userService.deviceLogout(userInfo)
                .flatMap(logoutSuccess -> sseService.notifyUser(userInfo.getUserId(), new SseOrderDto("logoutDevice", userInfo.getUserId(),null))
                        .then(ApiResponse.ok("로그아웃 성공")))
                .onErrorResume(CustomException.class,e -> ApiResponse.error("로그아웃 실패 : "+e.getMessage(), e.getStatus()));
    }

    @PostMapping("/signup")
    public Mono<ResponseEntity<ApiResponse>> signup(@RequestBody UserSignUpDto signUpDto){
        return userService.signUp(signUpDto)
                .flatMap(user -> ApiResponse.ok("회원가입 성공"))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("회원가입 실패: "+e.getMessage(),e.getStatus()));
    }

    @PostMapping("/refresh")
    public Mono<ResponseEntity<ApiResponse>> refreshToken(@RequestHeader("Authorization") String authHeader){
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            return ApiResponse.error("토큰이 제공되지 않았거나 형식이 올바르지 않습니다.", HttpStatus.BAD_REQUEST); // 400 Bad Request
        }

        String refreshToken = authHeader.substring(7);
        return userService.refreshAccessToken(refreshToken)
                .flatMap(tokens -> ApiResponse.ok("토큰이 정상적으로 갱신되었습니다.", tokens))
                .onErrorResume(CustomException.class,e -> ApiResponse.error("갱신 실패 : "+e.getMessage(), e.getStatus()));
    }

    @PatchMapping("/status")
    public Mono<ResponseEntity<ApiResponse>> changeUserStatus(@Login UserInfo userInfo, @RequestBody UserUpdateDto userUpdateDto){
        return userService.userUpdate(userInfo, userUpdateDto)
                .flatMap(reqFilteredUserDetailDto ->
                        sseService.notifyUser(userInfo.getUserId(), new SseUpdateDto("statusUpdate",null))
                                .thenReturn(reqFilteredUserDetailDto))
                .flatMap(result -> ApiResponse.ok("수정 완료", result))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("수정 실패 : " + e.getMessage(), e.getStatus()));
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PatchMapping("/{userId}/status")
    public Mono<ResponseEntity<ApiResponse>> adminChangeUserStatus(@PathVariable String userId, @RequestBody UserUpdateDto userUpdateDto) {
        return userService.adminUpdateUserStatus(userId, userUpdateDto)
                .flatMap(reqFilteredUserDetailDto ->
                        sseService.notifyUser(userId, new SseUpdateDto("statusUpdate",null))
                                .thenReturn(reqFilteredUserDetailDto))
                .flatMap(reqFilteredUserDetailDto ->
                        notificationService.saveAndPushNotification(userId,new NotificationSendDto("server","상태변경 알림","관리자에 의해 상태가 변경되었습니다."))
                                .thenReturn(reqFilteredUserDetailDto))
                .flatMap(updatedUser -> ApiResponse.ok("사용자 상태가 성공적으로 수정되었습니다.", updatedUser))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("사용자 상태 수정 실패 : " + e.getMessage(), e.getStatus()));
    }

    @GetMapping
    public Mono<ResponseEntity<ApiResponse>> getUserDetails(@Login UserInfo userInfo, @RequestParam(required = false) String username) {
        if(username != null && !username.isEmpty()) {
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

    @GetMapping("/team")
    public Mono<ResponseEntity<ApiResponse>> getMyTeam(@Login UserInfo userInfo){
        return userService.getTeamInfo(userInfo.getTeamCode())
                .flatMap(team -> ApiResponse.ok("조회완료", team))
                .switchIfEmpty(ApiResponse.ok("팀 조회 실패 : 해당 팀에 팀원이 존재하지 않습니다.", HttpStatus.NOT_FOUND))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("팀 조회 실패 : " + e.getMessage(), e.getStatus()));
    }


    @GetMapping("/search")
    public Mono<ResponseEntity<ApiResponse>> getTeam(@Login UserInfo userInfo,
                                                     @RequestParam(name = "teamcode", required = false) String teamCode,
                                                     @RequestParam(name = "classcode", required = false) String classCode,
                                                     @RequestParam(name = "locationcode", required = false) String locationCode) {
        int paramCount = 0;
        if (teamCode != null) paramCount++;
        if (classCode != null) paramCount++;
        if (locationCode != null) paramCount++;

        if (paramCount == 1) {
            if (teamCode != null) {
                return userService.getTeamInfo(teamCode)
                        .flatMap(team -> ApiResponse.ok("조회완료", team))
                        .switchIfEmpty(ApiResponse.ok("팀 조회 실패 : 해당 팀에 팀원이 존재하지 않습니다.", HttpStatus.NOT_FOUND))
                        .onErrorResume(CustomException.class, e -> ApiResponse.error("팀 조회 실패 : " + e.getMessage(), e.getStatus()));
            } else if (classCode != null) {
                return userService.getClassInfo(classCode)
                        .flatMap(classInfo -> ApiResponse.ok("조회완료", classInfo))
                        .onErrorResume(CustomException.class, e -> ApiResponse.error("클래스 조회 실패 : " + e.getMessage(), e.getStatus()));
            } else {
                return userService.getLocationInfo(locationCode)
                        .flatMap(locationInfo -> ApiResponse.ok("조회완료", locationInfo))
                        .onErrorResume(CustomException.class, e -> ApiResponse.error("지역 조회 실패 : " + e.getMessage(), e.getStatus()));
            }
        }else if(paramCount==0){
            return userService.getTeamInfo(userInfo.getTeamCode())
                    .flatMap(team -> ApiResponse.ok("조회완료", team))
                    .switchIfEmpty(ApiResponse.ok("팀 조회 실패 : 해당 팀에 팀원이 존재하지 않습니다.", HttpStatus.NOT_FOUND)).onErrorResume(CustomException.class, e -> ApiResponse.error("팀 조회 실패 : " + e.getMessage(), e.getStatus()));
        }
        else {
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

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/create")
    public Mono<ResponseEntity<ApiResponse>> createUser(@Login UserInfo userInfo, @RequestBody UserCreateDto userCreateDto){
        return userService.createUser(userInfo, userCreateDto)
                .flatMap(user -> ApiResponse.ok("생성완료",user))
                .onErrorResume(CustomException.class,e -> ApiResponse.error("생성 실패 : "+e.getMessage(), e.getStatus()));
    }

    @PostMapping(value = "/profileimg")
    public Mono<ResponseEntity<ApiResponse>> updateProfileImg(@Login UserInfo userInfo, @RequestHeader HttpHeaders headers, @RequestBody Flux<ByteBuffer> file){
        return userService.profileImgUpload(userInfo,headers,file)
                .flatMap(fileName ->
                        sseService.notifyUser(userInfo.getUserId(), new SseUpdateDto("statusUpdate",null))
                                .thenReturn(fileName))
                .flatMap(fileName -> ApiResponse.ok("수정완료",fileName))
                .onErrorResume(CustomException.class,e -> ApiResponse.error("수정 실패 : "+e.getMessage(), e.getStatus()));
    }

    @PostMapping(value = "/backgroundimg")
    public Mono<ResponseEntity<ApiResponse>> updatebackgroundImg(@Login UserInfo userInfo, @RequestHeader HttpHeaders headers, @RequestBody Flux<ByteBuffer> file){
        return userService.backgroundImgUpload(userInfo,headers,file)
                .flatMap(fileName ->
                        sseService.notifyUser(userInfo.getUserId(), new SseUpdateDto("statusUpdate",null))
                                .thenReturn(fileName))
                .flatMap(fileName -> ApiResponse.ok("수정완료",fileName))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("수정 실패 : " + e.getMessage(), e.getStatus()));
    }

    @PostMapping(value = "/widget")
    public Mono<ResponseEntity<ApiResponse>> addWidgetImg(@Login UserInfo userInfo, @RequestHeader HttpHeaders headers, @RequestBody Flux<ByteBuffer> file){
        return userService.WidgetImgUpload(userInfo,headers,file)
                .flatMap(fileName ->
                        sseService.notifyUser(userInfo.getUserId(), new SseUpdateDto("widgetUpdate",null))
                                .thenReturn(fileName))
                .flatMap(fileName -> ApiResponse.ok("등록완료",fileName))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("등록 실패 : " + e.getMessage(), e.getStatus()));
    }

    @GetMapping(value = "/widget")
    public Mono<ResponseEntity<ApiResponse>> getWidgetImg(@Login UserInfo userInfo){
        return userService.getWidgetImg(userInfo)
                .flatMap(fileName -> ApiResponse.ok("조회완료",fileName))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("조회 실패 : " + e.getMessage(), e.getStatus()));
    }

    @DeleteMapping(value = "/widget/{widgetId}")
    public Mono<ResponseEntity<ApiResponse>> deleteWidgetImg(@Login UserInfo userInfo, @PathVariable String widgetId){
        return userService.deleteWidgetImg(userInfo,widgetId)
                .flatMap(fileName ->
                        sseService.notifyUser(userInfo.getUserId(), new SseUpdateDto("widgetUpdate",null))
                                .thenReturn(fileName))
                .flatMap(fileName -> ApiResponse.ok("삭제완료",fileName))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("삭제 실패 : " + e.getMessage(), e.getStatus()));
    }

    @PostMapping("/fcmtoken")
    public Mono<ResponseEntity<ApiResponse>> saveFcmToken(@Login UserInfo userInfo, @RequestBody FcmTokenSaveDto fcmtokenSaveDto){
        return fcmService.saveOrUpdateFcmToken(userInfo.getUserId(), fcmtokenSaveDto)
                .flatMap(savedToken -> ApiResponse.ok("FCM 토큰 저장 성공", savedToken))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("FCM 토큰 저장 실패 : " + e.getMessage(), e.getStatus()));
    }

    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/locationinfo")
    public Mono<ResponseEntity<ApiResponse>> getallLocationSimpleInfo(@Login UserInfo userInfo){
        return userService.getAllLocationSimpleInfos()
                .flatMap(locationInfoList -> ApiResponse.ok("조회완료", locationInfoList))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("조회 실패 : " + e.getMessage(), e.getStatus()));
    }

    @PostMapping("/call")
    public Mono<ResponseEntity<ApiResponse>> callUser(@Login UserInfo userInfo, @RequestBody UserCallDto userCallDto) {
        return userService.callUser(userInfo, userCallDto.getUserId())
                .flatMap(usersInfo -> {
                    UserSearchInfoDto receiverInfo = usersInfo.getReceiverUserSearchInfoDto();
                    UserSearchInfoDto senderInfo = usersInfo.getSenderUserSearchInfoDto();
                    String senderProfileImg = senderInfo.getProfileImg();
                    log.info(String.valueOf(senderInfo));
                    log.info(String.valueOf(usersInfo));
                    return sseService.notifyUser(receiverInfo.getUserId(),
                                    new SseOrderDto("call", senderInfo.getUserName() + "," + senderProfileImg, userCallDto.getMessage()))
                            .then(notificationService.saveAndPushNotification(receiverInfo.getUserId(),new NotificationSendDto("call","호출",userCallDto.getMessage(),senderInfo.getUserName(),senderProfileImg)))
                            .thenReturn(usersInfo)
                            .flatMap(result -> ApiResponse.ok("호출 성공", result))
                            .onErrorResume(e -> ApiResponse.error("알람 전송 실패 : " + e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR));
                })
                .onErrorResume(CustomException.class, e -> ApiResponse.error("호출 실패 : " + e.getMessage(), e.getStatus()));
    }

}
