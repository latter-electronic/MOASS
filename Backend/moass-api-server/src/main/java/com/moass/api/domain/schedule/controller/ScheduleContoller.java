package com.moass.api.domain.schedule.controller;

import com.moass.api.domain.schedule.dto.TodoCreateDto;
import com.moass.api.domain.schedule.dto.TodoDeleteDto;
import com.moass.api.domain.schedule.service.ScheduleService;
import com.moass.api.global.annotaion.Login;
import com.moass.api.global.auth.dto.UserInfo;
import com.moass.api.global.exception.CustomException;
import com.moass.api.global.response.ApiResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
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
    @PostMapping("/todo")
    public Mono<ResponseEntity<ApiResponse>> CreateTodo(@Login UserInfo userInfo,@RequestBody TodoCreateDto todoContent){
        return scheduleService.CreateTodo(userInfo, todoContent)
                .flatMap(todo -> ApiResponse.ok("할일 생성 성공", todo))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("등록실패 : " + e.getMessage(), e.getStatus()));
    }

    @GetMapping("/todo")
    public Mono<ResponseEntity<ApiResponse>> getTodo(@Login UserInfo userInfo){
        return scheduleService.getTodo(userInfo)
                .flatMap(todos -> ApiResponse.ok("Todo 목록 조회 완료",todos))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("조회 실패 : " + e.getMessage(), e.getStatus()));
    }

    /**
     * Todo
     * 삭제시, sse 전송
     * @param userInfo
     * @param todoDeleteDto
     * @return
     */
    @DeleteMapping("/todo")
    public Mono<ResponseEntity<ApiResponse>> DeleteTodo(@Login UserInfo userInfo, @RequestBody TodoDeleteDto todoDeleteDto){
        return scheduleService.DeleteTodo(userInfo, todoDeleteDto)
                .flatMap(todo -> ApiResponse.ok("할일 삭제 성공", todo))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("삭제실패 : " + e.getMessage(), e.getStatus()));
    }
}
