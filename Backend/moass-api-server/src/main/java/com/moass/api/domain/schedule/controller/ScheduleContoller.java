package com.moass.api.domain.schedule.controller;

import com.moass.api.domain.schedule.service.ScheduleService;
import com.moass.api.global.annotaion.Login;
import com.moass.api.global.auth.dto.UserInfo;
import com.moass.api.global.exception.CustomException;
import com.moass.api.global.response.ApiResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Mono;

@Slf4j
@RestController
@RequestMapping("/schedule")
@RequiredArgsConstructor
public class ScheduleContoller {

    final ScheduleService scheduleService;

    /**
     * Todo
     * SSE 보내기
     * @param userInfo
     * @param todoContent
     * @return
     */
    @PostMapping("todo")
    public Mono<ResponseEntity<ApiResponse>> CreateTodo(@Login UserInfo userInfo, String todoContent){
        return scheduleService.CreateTodo(userInfo, todoContent)
                .flatMap(todo -> ApiResponse.ok("할일 생성 성공", todo))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("등록실패 : " + e.getMessage(), e.getStatus()));
    }
}
