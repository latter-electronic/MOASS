package com.moass.api.domain.webhook.service;


import com.moass.api.domain.user.repository.UserRepository;
import com.moass.api.domain.webhook.entity.GitlabToken;
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
                .map(GitlabToken::getGitlabTokenId);
    }

    private Mono<GitlabToken> createAndSaveGitlabToken(String teamCode) {
        String uuid = UUID.randomUUID().toString();
        GitlabToken newGitlabToken = new GitlabToken();
        newGitlabToken.setGitlabTokenId(uuid);
        newGitlabToken.setTeamCode(teamCode);
        log.info("생성중" + newGitlabToken);
        return gitlabRepository.saveForce(newGitlabToken)
                .then(Mono.just(newGitlabToken));
    }
}
