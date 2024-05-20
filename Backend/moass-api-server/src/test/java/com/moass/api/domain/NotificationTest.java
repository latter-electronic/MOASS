package com.moass.api.domain;

import com.moass.api.domain.notification.dto.NotificationSendDto;
import com.moass.api.domain.user.dto.UserLoginDto;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.reactive.AutoConfigureWebTestClient;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.data.mongodb.core.ReactiveMongoTemplate;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.test.web.reactive.server.WebTestClient;

import java.util.Map;

@ExtendWith(SpringExtension.class)
@ActiveProfiles("test")
@AutoConfigureWebTestClient
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@TestInstance(TestInstance.Lifecycle.PER_CLASS)
@DisplayName("알림 통합테스트")
public class NotificationTest {

    @Autowired
    private WebTestClient webTestClient;

    @Autowired
    private ReactiveMongoTemplate reactiveMongoTemplate;

    private String accessToken;

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

    @BeforeAll
    void setUp() {
        reactiveMongoTemplate.getCollectionNames()
                .flatMap(reactiveMongoTemplate::dropCollection)
                .blockLast(); // 테스트 설정이므로 blockLast()를 사용하여 동기적으로 처리합니다.
    }


    @Nested
    @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
    @DisplayName("[POST] 알람전송 /notification/send")
    class 알람전송{

            @Test
            @Order(1)
            @DisplayName("[200] 유저에게 알람전송 성공")
            void sendNotification() {

                UserLoginDto userLoginDto = new UserLoginDto("master@com", "1234");
                login(userLoginDto);
                NotificationSendDto notificationSendDto = new NotificationSendDto("server", "제목", "내용");

                webTestClient.post().uri("/notification/send?userid=9000001")
                        .header("Authorization", accessToken)
                        .bodyValue(notificationSendDto)
                        .exchange()
                        .expectStatus().isEqualTo(200)
                        .expectBody()
                        .jsonPath("$.status").isEqualTo("200");
            }

            @Test
            @Order(2)
            @DisplayName("[200] 팀에게 알람전송 성공")
            void 팀알람전송성공(){
                UserLoginDto userLoginDto = new UserLoginDto("master@com", "1234");
                login(userLoginDto);
                NotificationSendDto notificationSendDto = new NotificationSendDto("server", "제목", "내용");

                webTestClient.post().uri("/notification/send?teamcode=Z101")
                        .header("Authorization", accessToken)
                        .bodyValue(notificationSendDto)
                        .exchange()
                        .expectStatus().isEqualTo(200)
                        .expectBody()
                        .jsonPath("$.status").isEqualTo("200");
            }

        @Test
        @Order(3)
        @DisplayName("[200] 반에 알람전송 성공")
        void 반알람전송성공(){
            UserLoginDto userLoginDto = new UserLoginDto("master@com", "1234");
            login(userLoginDto);
            NotificationSendDto notificationSendDto = new NotificationSendDto("server", "제목", "내용");

            webTestClient.post().uri("/notification/send?classcode=Z1")
                    .header("Authorization", accessToken)
                    .bodyValue(notificationSendDto)
                    .exchange()
                    .expectStatus().isEqualTo(200)
                    .expectBody()
                    .jsonPath("$.status").isEqualTo("200");
        }

            @Test
            @Order(4)
            @DisplayName("[403] 권한부족")
            void 알람전송권한부족() {
                UserLoginDto userLoginDto = new UserLoginDto("Z001@com", "1234");
                login(userLoginDto);
                NotificationSendDto notificationSendDto = new NotificationSendDto("server", "제목2", "내용2");

                webTestClient.post().uri("/notification/send?userid=9000001")
                        .header("Authorization", accessToken)
                        .bodyValue(notificationSendDto)
                        .exchange()
                        .expectStatus().isEqualTo(403)
                        .expectBody()
                        .jsonPath("$.status").isEqualTo("403");
            }

    }
}
