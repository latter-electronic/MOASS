package com.moass.api.domain.schedule.service;

import com.moass.api.domain.schedule.entity.Course;
import com.moass.api.domain.schedule.entity.Curriculum;
import com.moass.api.domain.schedule.repository.CurriculumRepository;
import lombok.RequiredArgsConstructor;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class CurriculumService {

    private final CurriculumRepository curriculumRepository;

    @Value("${edussafy.id}")
    private String userId;

    @Value("${edussafy.pwd}")
    private String userPwd;

//    @Scheduled(cron = "0 0 8 ? * 1")
    public void crawlingCurriculum() {
        System.setProperty("webdriver.chrome.driver", "driver/chromedriver.exe");
        WebDriver driver = new ChromeDriver();
        driver.get("https://edu.ssafy.com/comm/login/SecurityLoginForm.do");

        driver.findElement(By.id("userId")).sendKeys(userId);
        driver.findElement(By.id("userPwd")).sendKeys(userPwd);
        driver.findElement(By.xpath("/html/body/div[1]/div/div/div[2]/form/div/div[2]/div[3]/a")).sendKeys(Keys.ENTER);

        driver.findElement(By.xpath("/html/body/div[1]/div[1]/div[1]/section[2]/div/div[1]/div/a")).sendKeys(Keys.ENTER);

//        driver.manage().window().fullscreen();
//
//        driver.findElement(By.xpath("/html/body/div[1]/div[1]/div[2]/div/div/div[3]/div/div[2]/div[2]/button[2]")).sendKeys(Keys.ENTER);

        WebElement totalCurriculum = driver.findElement(By.className("course"));
        List<WebElement> curriculumLinks = totalCurriculum.findElements(By.tagName("li"));

        for (WebElement curriculumLink : curriculumLinks) {
            Curriculum curriculum = new Curriculum();
            curriculum.setDate(curriculumLink.findElement(By.className("date")).getAttribute("innerText"));
            List<WebElement> courseLinks = curriculumLink.findElements(By.cssSelector("dl"));
            List<Course> courses = new ArrayList<>();

            for (WebElement courseLink : courseLinks) {
                Course course = Course.builder()
                        .period(courseLink.findElement(By.tagName("dt")).getAttribute("innerText"))
                        .majorCategory(courseLink.findElement(By.className("cate")).getAttribute("innerText"))
                        .minorCategory(courseLink.findElement(By.className("course-name")).getAttribute("innerText"))
                        .title(courseLink.findElement(By.className("subj")).getAttribute("innerText"))
                        .teacher(courseLink.findElement(By.className("name")).getAttribute("innerText"))
                        .room(courseLink.findElement(By.className("class-room")).getAttribute("innerText"))
                        .build();
                courses.add(course);
            }

            curriculum.setCourses(courses);
            curriculumRepository.save(curriculum);
        }

        driver.close();
    }
}
