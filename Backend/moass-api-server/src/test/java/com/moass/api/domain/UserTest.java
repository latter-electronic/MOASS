package com.moass.api.domain;

import com.moass.api.domain.file.dto.UploadResult;
import com.moass.api.domain.user.dto.UserCreateDto;
import com.moass.api.domain.user.dto.UserLoginDto;
import com.moass.api.domain.user.dto.UserSignUpDto;
import com.moass.api.global.service.S3Service;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.BDDMockito;
import org.mockito.Mock;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.reactive.AutoConfigureWebTestClient;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.TestContextManager;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.test.web.reactive.server.WebTestClient;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.nio.ByteBuffer;
import java.util.Map;

@ExtendWith(SpringExtension.class)
@ActiveProfiles("test")
@AutoConfigureWebTestClient
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
@TestInstance(TestInstance.Lifecycle.PER_CLASS)
@DisplayName("유저 컨트롤러 통합 테스트")
public class UserTest {
    @Autowired
    private WebTestClient webTestClient;

    @Mock
    private S3Service s3Service;

    //@MockBean
   // private UserService userService;

    private UserSignUpDto userSignupDto;
    private UserLoginDto userLoginDto;
    private String accessToken;

    private String refreshToken;



    UserSignUpDto signUp(UserSignUpDto userSignupDto){
        webTestClient.post().uri("/user/signup")
                .contentType(MediaType.APPLICATION_JSON)
                .bodyValue(userSignupDto)
                .exchange()
                .expectStatus().isOk()
                .expectBody()
                .jsonPath("$.status").isEqualTo(200);
        return userSignupDto;
    }

    void login(UserLoginDto userLoginDto) {
        Map responseBody = webTestClient.post().uri("/user/login")
                .contentType(MediaType.APPLICATION_JSON)
                .bodyValue(userLoginDto)
                .exchange()
                .expectStatus().isOk()
                .expectBody(Map.class) // 응답 본문을 Map으로 받음
                .returnResult()
                .getResponseBody();

        Map<String, String> data = (Map<String, String>) responseBody.get("data");
        this.accessToken = "Bearer " + data.get("accessToken");
        this.refreshToken ="Bearer "  +  data.get("refreshToken");
    }


    @BeforeAll
    void setUp() throws Exception {
        TestContextManager testContextManager = new TestContextManager(getClass());
        testContextManager.prepareTestInstance(this);
        signUp(new UserSignUpDto("test5@com", "1000005", "ssafyout!!!"));
    }



    @Nested
    @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
    @DisplayName("[POST] 가입 /user/signup")
    class 가입테스트 {

        @Test
        @Order(1)
        @DisplayName("[200] 정상가입")
        void 회원가입성공() {
            webTestClient.post().uri("/user/signup")
                    .contentType(MediaType.APPLICATION_JSON)
                    .bodyValue(new UserSignUpDto("test01@com", "1000001", "ssafyout001"))
                    .exchange()
                    .expectStatus().isOk()
                    .expectBody()
                    .jsonPath("$.status").isEqualTo("200");
        }


        @Test
        @Order(2)
        @DisplayName("[409] 중복된 이메일로 가입")
        void 중복된이메일회원가입() {
            webTestClient.post().uri("/user/signup")
                    .contentType(MediaType.APPLICATION_JSON)
                    .bodyValue(new UserSignUpDto("test01@com", "1000002", "ssafyout001"))
                    .exchange()
                    .expectStatus().isEqualTo(409)
                    .expectBody()
                    .jsonPath("$.status").isEqualTo("409");
        }

        @Test
        @Order(3)
        @DisplayName("[409] 중복된 학번으로 가입")
        void 중복된학번회원가입() {
            webTestClient.post().uri("/user/signup")
                    .contentType(MediaType.APPLICATION_JSON)
                    .bodyValue(new UserSignUpDto("test2@com", "1000001", "ssafyout001"))
                    .exchange()
                    .expectStatus().isEqualTo(409)
                    .expectBody()
                    .jsonPath("$.status").isEqualTo("409");
        }

        @Test
        @Order(4)
        @DisplayName("[200??]] 비밀번호가 비어있음")
        void 비밀번호가비어있음() {
            webTestClient.post().uri("/user/signup")
                    .contentType(MediaType.APPLICATION_JSON)
                    .bodyValue(new UserSignUpDto("test2@com", "1000002", ""))
                    .exchange()
                    .expectStatus().isEqualTo(200)
                    .expectBody()
                    .jsonPath("$.status").isEqualTo("200");
        }
    }

    @Nested
    @DisplayName("[POST] 리프레시토큰 /user/refresh")
    class 리프레시토큰{

            @Test
            @DisplayName("[200] 리프레시토큰")
            void 리프레시토큰성공(){
                webTestClient.post().uri("/user/refresh")
                        .header("Authorization", refreshToken)
                        .exchange()
                        .expectStatus().isOk()
                        .expectBody()
                        .jsonPath("$.status").isEqualTo("200");
            }

            @Test
            @DisplayName("[400] 리프레시토큰(잘못된 토큰제공)")
            void 리프레시토큰실패(){
                webTestClient.post().uri("/user/refresh")
                        .header("Authorization", refreshToken+"1")
                        .exchange()
                        .expectStatus().isEqualTo(401)
                        .expectBody()
                        .jsonPath("$.status").isEqualTo("401");
            }
    }

    @Nested
    @DisplayName("[POST] 로그인 /user/login")
    class 로그인테스트 {

        @Test
        @DisplayName("[200] 로그인 성공")
        void 로그인성공() {
            webTestClient.post().uri("/user/login")
                    .contentType(MediaType.APPLICATION_JSON)
                    .bodyValue(new UserLoginDto("test5@com", "ssafyout!!!"))
                    .exchange()
                    .expectStatus().isOk()
                    .expectBody()
                    .jsonPath("$.status").isEqualTo("200");
        }

        @Test
        @DisplayName("[401] 잘못된 이메일 또는 비밀번호")
        void 로그인실패() {
            webTestClient.post().uri("/user/login")
                    .contentType(MediaType.APPLICATION_JSON)
                    .bodyValue(new UserLoginDto("test5@com", "wrongpassword"))
                    .exchange()
                    .expectStatus().isEqualTo(401)
                    .expectBody()
                    .jsonPath("$.status").isEqualTo("401");
        }
    }

    @Nested
    @DisplayName("[GET] 조회 /user")
    class 조회 {

        @BeforeEach
        void setup(){
        // 사용자 로그인
            login(new UserLoginDto("test5@com", "ssafyout!!!"));

        }

        @Test
        @DisplayName("[200] 내 정보조회")
        void 내정보조회(){
            webTestClient.get().uri("/user")
                    .header("Authorization", accessToken) // 설정된 accessToken 사용
                    .exchange()
                    .expectStatus().isOk()
                    .expectBody()
                    .jsonPath("$.status").isEqualTo("200");
        }

        @Test
        @DisplayName("[400] 내 정보조회(잘못된 토큰제공)")
        void 내정보조회실패(){
            webTestClient.get().uri("/user")
                    .header("Authorization", accessToken+"1") // 설정된 accessToken 사용
                    .exchange()
                    .expectStatus().isEqualTo(401)
                    .expectBody()
                    .jsonPath("$.status").isEqualTo("401");
        }

        @Test
        @DisplayName("[200] 내 팀조회")
        void 내팀조회(){
            webTestClient.get().uri("/user/team")
                    .header("Authorization", accessToken) // 설정된 accessToken 사용
                    .exchange()
                    .expectStatus().isOk()
                    .expectBody()
                    .jsonPath("$.status").isEqualTo("200");
        }
    }

    @Nested
    @DisplayName("[POST] 유저 등록 /user/create (어드민)")
    class 유저등록 {

        @BeforeEach
        void setup(){
            // 사용자 로그인
            login(new UserLoginDto("master@com", "1234"));

        }
        @Test
        @DisplayName("[200] 유저등록")
        void 유저등록성공(){
            webTestClient.post().uri("/user/create")
                    .header("Authorization", accessToken) // 설정된 accessToken 사용
                    .contentType(MediaType.APPLICATION_JSON)
                    .bodyValue(new UserCreateDto("1100001",1,"E207","정종길",null))
                    .exchange()
                    .expectStatus().isOk()
                    .expectBody()
                    .jsonPath("$.status").isEqualTo("200");
        }

        @Test
        @DisplayName("[403] 등록권한 부족")
        void 유저등록권한부족(){
            login(new UserLoginDto("weon1009@gmail.com", "1234"));
            webTestClient.post().uri("/user/create")
                    .header("Authorization", accessToken) // 설정된 accessToken 사용
                    .contentType(MediaType.APPLICATION_JSON)
                    .bodyValue(new UserCreateDto("1100002",1,"E207","정종길",null))
                    .exchange()
                    .expectStatus().isEqualTo(403)
                    .expectBody()
                    .jsonPath("$.status").isEqualTo("403");
        }

        @Test
        @DisplayName("[409] 이미 존재하는 학번")
        void 유저학번중복(){
            webTestClient.post().uri("/user/create")
                    .header("Authorization", accessToken) // 설정된 accessToken 사용
                    .contentType(MediaType.APPLICATION_JSON)
                    .bodyValue(new UserCreateDto("1100001",1,"E207","정종길",null))
                    .exchange()
                    .expectStatus().isEqualTo(409)
                    .expectBody()
                    .jsonPath("$.status").isEqualTo("409");
        }
    }

    @Nested
    @DisplayName("[GET] 지역과 반만조회(어드민)")
    class 지역과반조회 {
        @Test
        @DisplayName("[200] 정상조회")
        void 지역과반정상조회(){
            login(new UserLoginDto("master@com", "1234"));
            webTestClient.get().uri("/user/locationinfo")
                    .header("Authorization", accessToken) // 설정된 accessToken 사용
                    .exchange()
                    .expectStatus().isOk()
                    .expectBody()
                    .jsonPath("$.status").isEqualTo("200");
        }

        @Test
        @DisplayName("[403] 등록권한 부족")
        void 지역과반조회권한부족(){
            login(new UserLoginDto("weon1009@gmail.com", "1234"));
            webTestClient.get().uri("/user/locationinfo")
                    .header("Authorization", accessToken) // 설정된 accessToken 사용
                    .exchange()
                    .expectStatus().isEqualTo(403)
                    .expectBody()
                    .jsonPath("$.status").isEqualTo("403");
        }

    }


    @Nested
    @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
    @DisplayName("[POST] 위젯 사진 등록 /user/widget")
    class 위젯사진등록 {

        @BeforeEach
        void setUp() {
            login(new UserLoginDto("z001@com", "1234"));
        }

        @Test
        @Order(1)
        @DisplayName("[200] 위젯 사진 등록 성공")
        void 위젯사진등록성공() {
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.IMAGE_JPEG);
            byte[] dummyImageData = "dummy image data".getBytes();
            headers.setContentLength(dummyImageData.length);
            Flux<ByteBuffer> dummyFile = Flux.just(ByteBuffer.wrap(dummyImageData));

            BDDMockito.given(s3Service.uploadHandler(headers, dummyFile))
                    .willReturn(Mono.just(new UploadResult(HttpStatus.CREATED, new String[]{"dummy-key"})));

            webTestClient.post().uri("/user/widget")
                    .header("Authorization", accessToken)
                    .header(HttpHeaders.CONTENT_TYPE, MediaType.IMAGE_JPEG_VALUE)
                    .header(HttpHeaders.CONTENT_LENGTH, String.valueOf(dummyImageData.length))
                    .body(dummyFile, ByteBuffer.class)
                    .exchange()
                    .expectStatus().isOk()
                    .expectBody()
                    .jsonPath("$.status").isEqualTo("200");
        }
    }

    @Nested
    @Order(2)
    @DisplayName("[GET] 위젯 사진 조회 /user/widget")
    class 위젯사진조회 {

        @BeforeEach
        void setUp() {
            login(new UserLoginDto("z001@com", "1234"));
        }

        @Test
        @DisplayName("[200] 위젯 사진 조회 성공")
        void 위젯사진조회성공() {

            webTestClient.get().uri("/user/widget")
                    .header("Authorization", accessToken)
                    .exchange()
                    .expectStatus().isOk()
                    .expectBody()
                    .jsonPath("$.status").isEqualTo("200");
        }
    }

    @Nested
    @Order(3)
    @DisplayName("[DELETE] 위젯 사진 삭제 /user/widget/{widgetId}")
    class 위젯사진삭제 {

        @BeforeEach
        void setUp() {
            login(new UserLoginDto("z001@com", "1234"));
        }

        @Test
        @DisplayName("[200] 위젯 사진 삭제 성공")
        void 위젯사진삭제성공() {
            // 위젯 사진 등록 먼저 수행
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.IMAGE_JPEG);
            byte[] dummyImageData = "dummy image data".getBytes();
            headers.setContentLength(dummyImageData.length);
            Flux<ByteBuffer> dummyFile = Flux.just(ByteBuffer.wrap(dummyImageData));

            BDDMockito.given(s3Service.uploadHandler(headers, dummyFile))
                    .willReturn(Mono.just(new UploadResult(HttpStatus.CREATED, new String[]{"dummy-key"})));

            webTestClient.post().uri("/user/widget")
                    .header("Authorization", accessToken)
                    .header(HttpHeaders.CONTENT_TYPE, MediaType.IMAGE_JPEG_VALUE)
                    .header(HttpHeaders.CONTENT_LENGTH, String.valueOf(dummyImageData.length))
                    .body(dummyFile, ByteBuffer.class)
                    .exchange()
                    .expectStatus().isOk()
                    .expectBody()
                    .jsonPath("$.status").isEqualTo("200");

            webTestClient.delete().uri("/user/widget/1")
                    .header("Authorization", accessToken)
                    .exchange()
                    .expectStatus().isOk()
                    .expectBody()
                    .jsonPath("$.status").isEqualTo("200");
        }

        @Test
        @DisplayName("[404] 위젯 사진 삭제 실패(존재하지않음)")
        void 위젯사진삭제실패() {

            webTestClient.delete().uri("/user/widget/widgetId")
                    .header("Authorization", accessToken)
                    .exchange()
                    .expectStatus().isEqualTo(404)
                    .expectBody()
                    .jsonPath("$.status").isEqualTo("404");
        }
    }

}
