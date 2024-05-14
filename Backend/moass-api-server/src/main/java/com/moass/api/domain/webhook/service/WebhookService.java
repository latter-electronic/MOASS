package com.moass.api.domain.webhook.service;


import com.moass.api.domain.user.repository.UserRepository;
import com.moass.api.domain.webhook.entity.GitlabHook;
import com.moass.api.domain.webhook.repository.GitlabRepository;
import com.moass.api.global.auth.dto.UserInfo;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;

import java.util.UUID;

@Slf4j
@RequiredArgsConstructor
@Service
public class WebhookService {
    private final UserRepository userRepository;
    private final GitlabRepository gitlabRepository;
    public Mono<String> createGitlabWebhookConnectUrl(UserInfo userInfo) {
        return gitlabRepository.findByTeamCode(userInfo.getTeamCode())
                        .switchIfEmpty(createAndSaveGitlabToken(userInfo.getTeamCode()))
                .map(GitlabHook::getGitlabTokenId);
    }

    private Mono<GitlabHook> createAndSaveGitlabToken(String teamCode) {
        String uuid = UUID.randomUUID().toString();
        GitlabHook newGitlabHook = new GitlabHook();
        newGitlabHook.setGitlabTokenId(uuid);
        newGitlabHook.setTeamCode(teamCode);
        log.info("생성중" + newGitlabHook);
        return gitlabRepository.saveForce(newGitlabHook)
                .then(Mono.just(newGitlabHook));
    }

    public Mono<String> validateGitlabToken(String gitlabTokenId) {
        return gitlabRepository.findByGitlabTokenId(gitlabTokenId)
                .flatMap(gitlabHook -> Mono.just(gitlabHook.getTeamCode())
                .switchIfEmpty(Mono.error(new RuntimeException("Invalid Gitlab Token"))));
    }
}
