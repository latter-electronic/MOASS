package com.moass.api.domain;

import com.moass.api.domain.device.dto.ReqDeviceLoginDto;
import com.moass.api.domain.reservation.dto.ReservationCreateDto;
import com.moass.api.domain.reservation.dto.ReservationInfoCreateDto;
import com.moass.api.domain.reservation.dto.ReservationPatchDto;
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

import java.time.LocalDate;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

@ExtendWith(SpringExtension.class)
@ActiveProfiles("test")
@AutoConfigureWebTestClient
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@TestInstance(TestInstance.Lifecycle.PER_CLASS)
@DisplayName("예약 통합테스트")
public class ReservationTest {

    @Autowired
    private WebTestClient webTestClient;

    private String accessToken;

    private Integer firstTestReservationId;
    private Integer secondTestReservationId;
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

    @BeforeAll
    void setUp() throws Exception {
        login(new UserLoginDto("master@com", "1234"));
        Map responseBody1 = webTestClient.post().uri("/reservation")
                .header("Authorization", accessToken)
                .contentType(MediaType.APPLICATION_JSON)
                .bodyValue(new ReservationCreateDto("Z1", "board", 2,"board","#111111",null))
                .exchange()
                .expectStatus().isOk()
                .expectBody(Map.class)
                .returnResult()
                .getResponseBody();

        Map responseBody2= webTestClient.post().uri("/reservation")
                .header("Authorization", accessToken)
                .contentType(MediaType.APPLICATION_JSON)
                .bodyValue(new ReservationCreateDto("Z1", "board", 2,"board","#111111", Arrays.asList(2, 4, 6)))
                .exchange()
                .expectStatus().isOk()
                .expectBody(Map.class)
                .returnResult()
                .getResponseBody();

        Map<String, Object> data1 = (Map<String, Object>) responseBody1.get("data");
        Map<String, Object> data2 = (Map<String, Object>) responseBody2.get("data");

        if (data1 != null && data1.get("reservationId") != null) {
            this.firstTestReservationId = (Integer) data1.get("reservationId");
        }
        if (data2 != null && data2.get("reservationId") != null) {
            this.secondTestReservationId = (Integer) data2.get("reservationId");
        }

    }

    @Nested
    @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
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
                    .bodyValue(new ReservationCreateDto("E2", "board", 4,"board","#111111",null))
                    .exchange()
                    .expectStatus().isOk()
                    .expectBody()
                    .jsonPath("$.status").isEqualTo("200");
        }

        @Test
        @Order(2)
        @DisplayName("[200] 정상생성(예약불가시간 지정)")
        void 예약생성성공2(){
            webTestClient.post().uri("/reservation")
                    .header("Authorization", accessToken)
                    .contentType(MediaType.APPLICATION_JSON)
                    .bodyValue(new ReservationCreateDto("E2", "board", 4,"board","#111111", Arrays.asList(2, 4, 6)))
                    .exchange()
                    .expectStatus().isOk()
                    .expectBody()
                    .jsonPath("$.status").isEqualTo("200");
        }

        @Test
        @Order(3)
        @DisplayName("[404] 존재하지 않는 반코드")
        void 예약생성실패1(){
            webTestClient.post().uri("/reservation")
                    .header("Authorization", accessToken)
                    .contentType(MediaType.APPLICATION_JSON)
                    .bodyValue(new ReservationCreateDto("G1", "board", 4,"board","#111111"))
                    .exchange()
                    .expectStatus().isEqualTo(404)
                    .expectBody()
                    .jsonPath("$.status").isEqualTo("404");
        }

        @Test
        @Order(4)
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

    @Nested
    @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
    @DisplayName("[PATCH] 예약 수정(어드민) /reservation")
    class 예약수정하기{
        @BeforeEach
        void setUp(){
            login(new UserLoginDto("master@com", "1234"));
        }

        @Test
        @Order(1)
        @DisplayName("[200] 정상수정")
        void 예약생성성공(){
            webTestClient.patch().uri("/reservation")
                    .header("Authorization", accessToken)
                    .contentType(MediaType.APPLICATION_JSON)
                    .bodyValue(new ReservationPatchDto(firstTestReservationId, "board", 4,"보드2","#111111"))
                    .exchange()
                    .expectStatus().isOk()
                    .expectBody()
                    .jsonPath("$.status").isEqualTo("200");
        }

        @Test
        @Order(2)
        @DisplayName("[200] 정상수정(예약불가시간 지정)")
        void 예약생성성공2(){
            webTestClient.patch().uri("/reservation")
                    .header("Authorization", accessToken)
                    .contentType(MediaType.APPLICATION_JSON)
                    .bodyValue(new ReservationPatchDto(secondTestReservationId, "board", 4,"보드2","#111111", LocalDate.now(), Arrays.asList(1, 2, 3, 4, 5, 6, 7)))
                    .exchange()
                    .expectStatus().isOk()
                    .expectBody()
                    .jsonPath("$.status").isEqualTo("200");
        }

        @Test
        @Order(3)
        @DisplayName("[200] 예약불가 시간 지정된 시간대를 다시 예약불가 시간 지정")
        void 예약수정실패1(){
            webTestClient.patch().uri("/reservation")
                    .header("Authorization", accessToken)
                    .contentType(MediaType.APPLICATION_JSON)
                    .bodyValue(new ReservationPatchDto(secondTestReservationId, "board", 4,"보드2","#111111", LocalDate.now(), Arrays.asList(2, 4, 6)))
                    .exchange()
                    .expectStatus().isEqualTo(200)
                    .expectBody()
                    .jsonPath("$.status").isEqualTo("200");
        }
    }

    @Nested
    @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
    @DisplayName("[POST] 예약하기/reservationinfo")
    class 예약하기 {
        @BeforeEach
        void setUp() {
            login(new UserLoginDto("z001@com", "1234"));
        }

        @Test
        @Order(1)
        @DisplayName("[200] 정상예약")
        void 예약성공() {
            webTestClient.post().uri("/reservationinfo")
                    .header("Authorization", accessToken)
                    .contentType(MediaType.APPLICATION_JSON)
                    .bodyValue(new ReservationInfoCreateDto(firstTestReservationId, "홍길동팀",Arrays.asList(1,2), LocalDate.now(),Arrays.asList("9000001","9000002")))
                    .exchange()
                    .expectStatus().isOk()
                    .expectBody()
                    .jsonPath("$.status").isEqualTo("200");
        }

        @Test
        @Order(2)
        @DisplayName("[409] 예약시간 만료")
        void 예약실패() {
            webTestClient.post().uri("/reservationinfo")
                    .header("Authorization", accessToken)
                    .contentType(MediaType.APPLICATION_JSON)
                    .bodyValue(new ReservationInfoCreateDto(firstTestReservationId, "홍길동팀",Arrays.asList(3,4), LocalDate.now(),Arrays.asList("9000001","9000002")))
                    .exchange()
                    .expectStatus().isEqualTo(409)
                    .expectBody()
                    .jsonPath("$.status").isEqualTo("409");
        }

        @Test
        @Order(3)
        @DisplayName("[409] 이미 예약중인 시간대")
        void 예약실패2() {
            login(new UserLoginDto("z003@com", "1234"));

            webTestClient.post().uri("/reservationinfo")
                    .header("Authorization", accessToken)
                    .contentType(MediaType.APPLICATION_JSON)
                    .bodyValue(new ReservationInfoCreateDto(firstTestReservationId, "최길동팀",Arrays.asList(1), LocalDate.now(),Arrays.asList("9000003")))
                    .exchange()
                    .expectStatus().isEqualTo(409)
                    .expectBody()
                    .jsonPath("$.status").isEqualTo("409");
        }
    }

    @Nested
    @DisplayName("[GET] 예약 조회")
    class 예약조회 {

        @BeforeEach
        void setUp() {
            login(new UserLoginDto("z001@com", "1234"));
        }

        @Test
        @Order(1)
        @DisplayName("[200] 오늘 예약 정보 조회 성공")
        void 오늘예약조회성공() {
            webTestClient.get().uri("/reservationinfo/today")
                    .header("Authorization", accessToken)
                    .exchange()
                    .expectStatus().isEqualTo(200)
                    .expectBody()
                    .jsonPath("$.status").isEqualTo("200")
                    .jsonPath("$.data").isNotEmpty();
        }

        @Test
        @Order(2)
        @DisplayName("[200] 일주일 예약 정보 조회 성공")
        void 일주일예약조회성공() {
            webTestClient.get().uri("/reservationinfo/week")
                    .header("Authorization", accessToken)
                    .exchange()
                    .expectStatus().isEqualTo(200)
                    .expectBody()
                    .jsonPath("$.status").isEqualTo("200")
                    .jsonPath("$.data").isNotEmpty();
        }
    }
}
