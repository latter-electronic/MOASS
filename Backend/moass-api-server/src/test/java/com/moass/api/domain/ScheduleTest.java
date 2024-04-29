package com.moass.api.domain;


import com.moass.api.domain.schedule.dto.TodoCreateDto;
import com.moass.api.domain.schedule.dto.TodoDeleteDto;
import com.moass.api.domain.schedule.dto.TodoDetailDto;
import com.moass.api.domain.schedule.dto.TodoUpdateDto;
import com.moass.api.domain.schedule.entity.Todo;
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
@DisplayName(" 스케쥴 통합 테스트")
public class ScheduleTest {

    @Autowired
    private WebTestClient webTestClient;

    private TodoCreateDto todoCreateDto;
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
        this.refreshToken = data.get("refreshToken");
    }

    String todoCreate(TodoCreateDto todoCreateDto){
        Map responseBody = webTestClient.post().uri("/schedule/todo")
                .header("Authorization", accessToken)
                .contentType(MediaType.APPLICATION_JSON)
                .bodyValue(todoCreateDto)
                .exchange()
                .expectStatus().isOk()
                .expectBody(Map.class) // 응답 본문을 Map으로 받음
                .returnResult()
                .getResponseBody();
        Map<String, String> data =  (Map<String, String>) responseBody.get("data");
        return data.get("todoId");
    }

    @BeforeAll
    void setUp() throws Exception {
        TestContextManager testContextManager = new TestContextManager(getClass());
        testContextManager.prepareTestInstance(this);
        signUp(new UserSignUpDto("test6@com", "1000006", "1234"));
        login(new UserLoginDto("test6@com", "1234"));
    }


    @Nested
    @DisplayName("[POST]Todo생성 테스트")
    class Todo생성{

        @Test
        @Order(1)
        @DisplayName("[200] Todo 정상생성")
        void Todo생성성공(){
            TodoCreateDto todoCreateDto = new TodoCreateDto();
            todoCreateDto.setContent("Todo테스트");
            webTestClient.post().uri("/schedule/todo")
                    .header("Authorization", accessToken)
                    .contentType(MediaType.APPLICATION_JSON)
                    .bodyValue(todoCreateDto)
                    .exchange()
                    .expectStatus().isOk()
                    .expectBody()
                    .jsonPath("$.status").isEqualTo(200);
        }

        @Test
        @Order(2)
        @DisplayName("[400] content 전달 X")
        void Todo생성에러(){
            webTestClient.post().uri("/schedule/todo")
                    .header("Authorization", accessToken)
                    .contentType(MediaType.APPLICATION_JSON)
                    .exchange()
                    .expectStatus().isEqualTo(400)
                    .expectBody()
                    .jsonPath("$.status").isEqualTo("400");
        }

    }

    @Nested
    @DisplayName("[Delete] Todo 삭제")
    class Todo삭제{
        @Test
        @Order(1)
        @DisplayName("[200] Todo 삭제 성공")
        void Todo삭제성공(){

            TodoCreateDto todoCreateDto = new TodoCreateDto();
            todoCreateDto.setContent("Todo테스트2");
            String todoId = todoCreate(todoCreateDto);

            webTestClient.delete().uri("/schedule/todo/"+todoId)
                    .header("Authorization", accessToken)
                    .exchange()
                    .expectStatus().isEqualTo(200)
                    .expectBody()
                    .jsonPath("$.status").isEqualTo(200);
        }

        @Test
        @Order(2)
        @DisplayName("[404] 없는 Todo 삭제")
        void Todo삭제실패(){


            webTestClient.delete().uri("/schedule/todo/22")
                    .header("Authorization", accessToken)
                    .exchange()
                    .expectStatus().isEqualTo(500)
                    .expectBody()
                    .jsonPath("$.status").isEqualTo("500");
        }
    }

    @Nested
    @DisplayName("[Patch] Todo 수정")
    class Todo수정{

        @Test
        @Order(1)
        @DisplayName("[200] 정상수정")
        void Todo수정성공(){
            TodoCreateDto todoCreateDto = new TodoCreateDto();
            todoCreateDto.setContent("Todo테스트2");
            String todoId = todoCreate(todoCreateDto);

            TodoUpdateDto todoUpdateDto = new TodoUpdateDto();
            todoUpdateDto.setTodoId(todoId);
            todoUpdateDto.setContent("수정된 Todo");
            webTestClient.patch().uri("/schedule/todo")
                    .header("Authorization", accessToken)
                    .contentType(MediaType.APPLICATION_JSON)
                    .bodyValue(todoUpdateDto)
                    .exchange()
                    .expectStatus().isEqualTo(200)
                    .expectBody()
                    .jsonPath("$.status").isEqualTo("200");
        }

        @Test
        @Order(2)
        @DisplayName("[400] 바뀐게 없을경우(내용이)")
        void Todo수정실패(){
            TodoCreateDto todoCreateDto = new TodoCreateDto();
            todoCreateDto.setContent("Todo테스트2");
            String todoId = todoCreate(todoCreateDto);

            TodoUpdateDto todoUpdateDto = new TodoUpdateDto();
            todoUpdateDto.setTodoId(todoId);
            todoUpdateDto.setContent("Todo테스트2");
            webTestClient.patch().uri("/schedule/todo")
                    .header("Authorization", accessToken)
                    .contentType(MediaType.APPLICATION_JSON)
                    .bodyValue(todoUpdateDto)
                    .exchange()
                    .expectStatus().isEqualTo(400)
                    .expectBody()
                    .jsonPath("$.status").isEqualTo("400");
        }

        @Test
        @Order(2)
        @DisplayName("[400] 바뀐게 없을경우(flag)")
        void Todo수정실패2(){
            TodoCreateDto todoCreateDto = new TodoCreateDto();
            todoCreateDto.setContent("Todo테스트2");
            String todoId = todoCreate(todoCreateDto);

            TodoUpdateDto todoUpdateDto = new TodoUpdateDto();
            todoUpdateDto.setTodoId(todoId);
            todoUpdateDto.setCompletedFlag(false);
            webTestClient.patch().uri("/schedule/todo")
                    .header("Authorization", accessToken)
                    .contentType(MediaType.APPLICATION_JSON)
                    .bodyValue(todoUpdateDto)
                    .exchange()
                    .expectStatus().isEqualTo(400)
                    .expectBody()
                    .jsonPath("$.status").isEqualTo("400");
        }
    }
}
