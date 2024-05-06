package com.moass.api.domain;

import com.moass.api.domain.device.dto.ReqDeviceLoginDto;
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
import org.springframework.test.context.TestContextManager;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.test.web.reactive.server.WebTestClient;

import java.util.Map;

@ExtendWith(SpringExtension.class)
@ActiveProfiles("test")
@AutoConfigureWebTestClient
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
@TestInstance(TestInstance.Lifecycle.PER_CLASS)
@DisplayName("예약 통합테스트")
public class ReservationTest {

    @Autowired
    private WebTestClient webTestClient;

    private String accessToken;

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
    }


    @Nested
    @DisplayName("[POST] 예약 생성(어드민) /reservation")
    class 예약생성하기{
        @BeforeEach
        void setUp(){
            login(new UserLoginDto("master@com", "1234"));
        }

        @Test
        @Order(1)
        @DisplayName("[200] 정상생성")
        void 예약생성성공(){
            webTestClient.post().uri("/reservation")
                    .header("Authorization", accessToken)
                    .contentType(MediaType.APPLICATION_JSON)
                    .bodyValue(new ReservationCreateDto("E2", "board", 4,"board","#111111"))
                    .exchange()
                    .expectStatus().isOk()
                    .expectBody()
                    .jsonPath("$.status").isEqualTo("200");
        }

        @Test
        @Order(2)
        @DisplayName("[400] 존재하지 않는 반코드")
        void 예약생성실패1(){
            webTestClient.post().uri("/reservation")
                    .header("Authorization", accessToken)
                    .contentType(MediaType.APPLICATION_JSON)
                    .bodyValue(new ReservationCreateDto("G1", "board", 4,"board","#111111"))
                    .exchange()
                    .expectStatus().isEqualTo(400)
                    .expectBody()
                    .jsonPath("$.status").isEqualTo("400");
        }

        @Test
        @Order(3)
        @DisplayName("[403] 권한 부족")
        void 예약생성실패2(){
            login(new UserLoginDto("Z001@com", "1234"));

            webTestClient.post().uri("/reservation")
                    .header("Authorization", accessToken)
                    .contentType(MediaType.APPLICATION_JSON)
                    .bodyValue(new ReservationCreateDto("G1", "board", 4,"board","#111111"))
                    .exchange()
                    .expectStatus().isEqualTo(403)
                    .expectBody()
                    .jsonPath("$.status").isEqualTo("403");
        }

    }
}
