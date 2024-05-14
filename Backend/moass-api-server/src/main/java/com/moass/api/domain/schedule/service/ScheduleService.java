package com.moass.api.domain.schedule.service;

import com.moass.api.domain.schedule.dto.*;
import com.moass.api.domain.schedule.entity.Course;
import com.moass.api.domain.schedule.entity.Curriculum;
import com.moass.api.domain.schedule.entity.Todo;
import com.moass.api.domain.schedule.repository.CurriculumRepository;
import com.moass.api.domain.schedule.repository.TodoRepository;
import com.moass.api.global.auth.dto.UserInfo;
import com.moass.api.global.exception.CustomException;
import com.mongodb.reactivestreams.client.MongoClient;
import com.mongodb.reactivestreams.client.MongoClients;
import lombok.RequiredArgsConstructor;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.http.HttpStatus;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ScheduleService {

    private final TodoRepository todoRepository;
    private final CurriculumRepository curriculumRepository;

    public Mono<TodoDetailDto> CreateTodo(UserInfo userInfo, TodoCreateDto todoContent){
       Todo todo = Todo.builder()
                .userId(userInfo.getUserId())
                .content(todoContent.getContent())
                .completedFlag(false)
               .createdAt(LocalDateTime.now())
               .updatedAt(LocalDateTime.now())
               .completedAt(null)
                .build();
        return todoRepository.save(todo)
                .map(savedTodo -> new TodoDetailDto(savedTodo));


    }

    public Mono<List<TodoDetailDto>> getTodo(UserInfo userInfo) {
        return todoRepository.findAllByUserId(userInfo.getUserId(),Sort.by(Sort.Direction.ASC,"createdAt"))
                .collectList()
                .map(todos -> todos.stream().map(TodoDetailDto::new).toList())
                .switchIfEmpty(Mono.error(new IllegalArgumentException("Todo를 찾을 수 없습니다.")));
    }

    public Mono<TodoDetailDto> DeleteTodo(UserInfo userInfo, String todoId) {
        return todoRepository.findByTodoIdAndUserId(todoId,userInfo.getUserId())
                .switchIfEmpty(Mono.error(new IllegalArgumentException("Todo를 찾을 수 없습니다.")))
                .flatMap(todo -> todoRepository.delete(todo)
                        .thenReturn(todo)
                        .map(deletedTodo -> new TodoDetailDto(deletedTodo)));
    }

    public Mono<Object> UpdateDto(UserInfo userInfo, TodoUpdateDto todoUpdateDto) {
        return todoRepository.findByTodoIdAndUserId(todoUpdateDto.getTodoId(),userInfo.getUserId())
                .switchIfEmpty(Mono.error(new CustomException("Todo를 찾을 수 없습니다.", HttpStatus.NOT_FOUND)))
                .flatMap(todo -> {
                    boolean isUpdated = false;
                    if(todoUpdateDto.getContent() != null&&!todo.getContent().equals(todoUpdateDto.getContent())){
                        todo.setContent(todoUpdateDto.getContent());
                        isUpdated = true;
                    }
                    if(todoUpdateDto.getCompletedFlag() != null&&todo.getCompletedFlag()!=todoUpdateDto.getCompletedFlag()){
                        todo.setCompletedFlag(todoUpdateDto.getCompletedFlag());
                        isUpdated=true;
                        if(todoUpdateDto.getCompletedFlag()){
                            todo.setCompletedAt(LocalDateTime.now());
                        }else{
                            todo.setCompletedAt(null);
                        }
                    }
                    if(isUpdated) {
                        todo.setUpdatedAt(LocalDateTime.now());
                        return todoRepository.save(todo)
                                .map(savedTodo -> new TodoDetailDto(savedTodo));
                    }else{
                        return Mono.error(new CustomException("변경된 사항이 없습니다.", HttpStatus.BAD_REQUEST));
                    }
                });
    }

    @Scheduled(fixedDelay = 60000)
    public Mono<CurriculumDto> crawlingCurriculum() {
        System.setProperty("webdriver.chrome.driver", "driver/chromedriver.exe");
        WebDriver driver = new ChromeDriver();
        driver.get("https://edu.ssafy.com/comm/login/SecurityLoginForm.do");

        driver.findElement(By.id("userId")).sendKeys("ghehd1125@gmail.com");
        driver.findElement(By.id("userPwd")).sendKeys("ehdgh110!!");
        driver.findElement(By.xpath("//*[@id=\"wrap\"]/div/div/div[2]/form/div/div[2]/div[3]/a")).sendKeys(Keys.ENTER);

        driver.findElement(By.xpath("//*[@id=\"header\"]/div[1]/div[2]/ul/li[2]/a")).click();

        List<WebElement> curriculumLinks = driver.findElements(By.xpath("//*[@id=\"_crclmDayTargetId\"]/li"));
        List<Curriculum> curriculums = new ArrayList<>();

        Mono<CurriculumDto> ret = null;

        for (WebElement curriculumLink : curriculumLinks) {
            Curriculum curriculum = new Curriculum();
            curriculum.setDate(curriculumLink.findElement(By.className("date")).getAttribute("innerHtml"));
            List<WebElement> courseLinks = curriculumLink.findElements(By.cssSelector("dl"));
            List<Course> courses = new ArrayList<>();

            for (WebElement courseLink : courseLinks) {
                Course course = Course.builder()
                        .majorCategory(courseLink.findElement(By.className("cate")).getAttribute("innerHtml"))
                        .minorCategory(courseLink.findElement(By.className("course-name")).getAttribute("innerHtml"))
                        .title(courseLink.findElement(By.className("subj")).getAttribute("innerHtml"))
                        .teacher(courseLink.findElement(By.className("name")).getAttribute("innerHtml"))
                        .room(courseLink.findElement(By.className("class-room")).getAttribute("innerHtml"))
                        .build();
                courses.add(course);
            }

            curriculum.setCourses(courses);
            ret = curriculumRepository.save(curriculum)
                    .map(savedCurriculum -> new CurriculumDto(savedCurriculum));
        }

        driver.close();

        return ret;
    }

    public Mono<List<CurriculumDto>> getCurriculum() {
        String URL = null;
        return null;
    }
}
