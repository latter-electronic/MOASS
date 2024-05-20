package com.moass.api.domain.schedule.controller;

import com.moass.api.domain.schedule.dto.TodoCreateDto;
import com.moass.api.domain.schedule.dto.TodoUpdateDto;
import com.moass.api.domain.schedule.service.CurriculumService;
import com.moass.api.domain.schedule.service.ScheduleService;
import com.moass.api.global.annotaion.Login;
import com.moass.api.global.auth.dto.UserInfo;
import com.moass.api.global.exception.CustomException;
import com.moass.api.global.response.ApiResponse;
import com.moass.api.global.sse.dto.SseUpdateDto;
import com.moass.api.global.sse.service.SseService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Mono;

@Slf4j
@RestController
@RequestMapping("/schedule")
@RequiredArgsConstructor
public class ScheduleController {

    final ScheduleService scheduleService;
    final SseService sseService;
    final CurriculumService curriculumService;
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
                .flatMap(fileName ->
                        sseService.notifyUser(userInfo.getUserId(), new SseUpdateDto("todotUpdate",null))
                                .thenReturn(fileName))
                .flatMap(todo -> ApiResponse.ok("할일 생성 성공", todo))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("등록실패 : " + e.getMessage(), e.getStatus()));
    }

    @GetMapping("/todo")
    public Mono<ResponseEntity<ApiResponse>> getTodo(@Login UserInfo userInfo){
        return scheduleService.getTodo(userInfo)
                .flatMap(todos -> ApiResponse.ok("Todo 목록 조회 완료",todos))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("조회 실패 : " + e.getMessage(), e.getStatus()));
    }

    @DeleteMapping("/todo/{todoId}")
    public Mono<ResponseEntity<ApiResponse>> DeleteTodo(@Login UserInfo userInfo, @PathVariable String todoId){
        return scheduleService.DeleteTodo(userInfo, todoId)
                .flatMap(fileName ->
                        sseService.notifyUser(userInfo.getUserId(), new SseUpdateDto("todotUpdate",null))
                                .thenReturn(fileName))
                .flatMap(todo -> ApiResponse.ok("할일 삭제 성공", todo))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("삭제실패 : " + e.getMessage(), e.getStatus()));
    }

    @PatchMapping("/todo")
    public Mono<ResponseEntity<ApiResponse>> UpdateTodo(@Login UserInfo userInfo,@Validated @RequestBody TodoUpdateDto todoUpdateDto){
        return scheduleService.UpdateDto(userInfo,todoUpdateDto)
                .flatMap(fileName ->
                        sseService.notifyUser(userInfo.getUserId(), new SseUpdateDto("todotUpdate",null))
                                .thenReturn(fileName))
                .flatMap(todo -> ApiResponse.ok("할일 수정 성공", todo))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("수정실패 : "+ e.getMessage(), e.getStatus()));
    }

    @GetMapping("/curriculum/{date}")
    public Mono<ResponseEntity<ApiResponse>> getCurriculum(@Login UserInfo userInfo, @PathVariable String date){
        return scheduleService.getCurriculum(date)
                .flatMap(curriculum -> ApiResponse.ok("Curriculum 조회 완료", curriculum))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("조회 실패 : " + e.getMessage(), e.getStatus()));
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/crawl")
    public Mono<ResponseEntity<ApiResponse>> crawlingCurriculum(){
        return Mono.fromRunnable(() -> curriculumService.crawlingCurriculum())
                .then(ApiResponse.ok("Curriculum crawling started"))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("크롤링 실패 : " + e.getMessage(), e.getStatus()));
    }
}
