package com.moass.api.domain;

import com.moass.api.domain.device.dto.Coordinate;
import com.moass.api.domain.device.dto.ReqDeviceLoginDto;
import com.moass.api.domain.device.dto.ReqDeviceLogoutDto;
import com.moass.api.domain.reservation.dto.ReservationCreateDto;
import com.moass.api.domain.user.dto.UserLoginDto;
import com.moass.api.domain.user.dto.UserSignUpDto;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.reactive.AutoConfigureWebTestClient;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.TestContextManager;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.test.web.reactive.server.WebTestClient;
import org.springframework.transaction.annotation.Transactional;

import java.util.Map;

@ExtendWith(SpringExtension.class)
@ActiveProfiles("test")
@AutoConfigureWebTestClient
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@TestInstance(TestInstance.Lifecycle.PER_CLASS)
@DisplayName("기기 컨트롤러 통합 테스트")
public class DeviceTest {


    @Autowired
    private WebTestClient webTestClient;

    private ReqDeviceLoginDto reqDeviceLoginDto;

    private ReqDeviceLogoutDto reqDeviceLogoutDto;
    private String accessToken;

    private String accessToken2;
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
        signUp(new UserSignUpDto("test04@com", "1000004", "ssafyout4"));
    }


    @Nested
    @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
    @DisplayName("[POST] 기기로그인 /device/login")
    class 기기로그인{

        @Test
        @Order(1)
        @DisplayName("[200] 정상로그인")
        void 기기로그인성공(){
            webTestClient.post().uri("/device/login")
                    .contentType(MediaType.APPLICATION_JSON)
                    .bodyValue(new ReqDeviceLoginDto("DDDD4", "AAAA4"))
                    .exchange()
                    .expectStatus().isOk()
                    .expectBody()
                    .jsonPath("$.status").isEqualTo(200);
        }

        @Test
        @Order(2)
        @DisplayName("[404] 없는 deviceId")
        void 없는기기(){
            webTestClient.post().uri("/device/login")
                    .contentType(MediaType.APPLICATION_JSON)
                    .bodyValue(new ReqDeviceLoginDto("DDDA4", "AAAA4"))
                    .exchange()
                    .expectStatus().isEqualTo(404)
                    .expectBody()
                    .jsonPath("$.status").isEqualTo("404");
        }

        @Test
        @Order(3)
        @DisplayName("[404] 없는 카드Id")
        void 없는카드(){
            webTestClient.post().uri("/device/login")
                    .contentType(MediaType.APPLICATION_JSON)
                    .bodyValue(new ReqDeviceLoginDto("DDDA1", "AAAD4"))
                    .exchange()
                    .expectStatus().isEqualTo(404)
                    .expectBody()
                    .jsonPath("$.status").isEqualTo("404");
        }

        @Test
        @Order(4)
        @DisplayName("[400] 이미 로그인함")
        void 기기중복로그인(){
            webTestClient.post().uri("/device/login")
                    .contentType(MediaType.APPLICATION_JSON)
                    .bodyValue(new ReqDeviceLoginDto("DDDD4", "AAAA4"))
                    .exchange()
                    .expectStatus().isEqualTo(400)
                    .expectBody()
                    .jsonPath("$.status").isEqualTo(400);
        }
    }

    @Nested
    @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
    @DisplayName("[POST] 로그아웃 /device/logout")
    class 로그아웃{

            @Test
            @Order(1)
            void setUp(){
                login(new UserLoginDto("test04@com", "ssafyout4"));

                    webTestClient.post().uri("/device/login")
                            .contentType(MediaType.APPLICATION_JSON)
                            .bodyValue(new ReqDeviceLoginDto("DDDD4", "AAAA4"))
                            .exchange()
                            .expectStatus().isOk()
                            .expectBody()
                            .jsonPath("$.status").isEqualTo(200);

            }

            @Test
            @Order(2)
            @DisplayName("[200] 정상로그아웃")
            void 로그아웃성공(){
                webTestClient.post().uri("/device/logout")
                        .header("Authorization", accessToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .exchange()
                        .expectStatus().isOk()
                        .expectBody()
                        .jsonPath("$.status").isEqualTo(200);
            }

        @Test
        @Order(3)
        @DisplayName("[400] 이미 로그아웃")
        void 로그아웃실패(){
            webTestClient.post().uri("/device/logout")
                    .header("Authorization", accessToken)
                    .contentType(MediaType.APPLICATION_JSON)
                    .exchange()
                    .expectStatus().isEqualTo(400)
                    .expectBody()
                    .jsonPath("$.status").isEqualTo(400);
        }

    }

    @Nested
    @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
    @DisplayName("[PATCH] 기기좌표변경 /device/coordinate")
    class 기기좌표변경{

        @Test
        @Order(1)
        @DisplayName("[200] 정상좌표변경")
        void 좌표변경성공(){
            webTestClient.patch().uri("/device/coordinate/DDDD1")
                    .contentType(MediaType.APPLICATION_JSON)
                    .bodyValue(new Coordinate(1,2))
                    .exchange()
                    .expectStatus().isOk()
                    .expectBody()
                    .jsonPath("$.status").isEqualTo("200");
        }

        @Test
        @Order(2)
        @DisplayName("[200] 정상좌표변경(double)")
        void 좌표변경성공1(){
            webTestClient.patch().uri("/device/coordinate/DDDD1")
                    .contentType(MediaType.APPLICATION_JSON)
                    .bodyValue(Map.of("xcoord", 3.5, "ycoord", 2))
                    .exchange()
                    .expectStatus().isOk()
                    .expectBody()
                    .jsonPath("$.status").isEqualTo("200");
        }

        @Test
        @Order(3)
        @DisplayName("[400] 잘못된 좌표")
        void 좌표변경실패1(){
            webTestClient.patch().uri("/device/coordinate/DDDD1")
                    .contentType(MediaType.APPLICATION_JSON)
                    .bodyValue(Map.of("xcoord", "132ㄱ", "ycoord", 2))
                    .exchange()
                    .expectStatus().isEqualTo(400)
                    .expectBody()
                    .jsonPath("$.status").isEqualTo(400);
        }

    }
    }
