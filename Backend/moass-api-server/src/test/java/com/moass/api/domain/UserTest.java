package com.moass.api.domain;

import com.moass.api.domain.user.dto.UserLoginDto;
import com.moass.api.domain.user.dto.UserSignUpDto;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.reactive.AutoConfigureWebTestClient;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.TestContextManager;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.test.web.reactive.server.WebTestClient;
import org.springframework.transaction.annotation.Transactional;

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
    @DisplayName("[POST] Signup /user/signup")
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
    }

}
