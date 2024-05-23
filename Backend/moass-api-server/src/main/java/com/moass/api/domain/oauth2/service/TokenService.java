package com.moass.api.domain.oauth2.service;

import com.moass.api.domain.oauth2.entity.MMToken;
import com.moass.api.domain.oauth2.repository.MmTokenRepository;
import com.moass.api.global.exception.CustomException;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import reactor.core.publisher.Mono;

import java.time.LocalDateTime;

@Slf4j
@Service
@AllArgsConstructor
public class TokenService {

    private final MmTokenRepository mmTokenRepository;

    @Transactional(propagation = Propagation.REQUIRES_NEW, noRollbackFor ={CustomException.class})
    protected Mono<MMToken> findAndExpireMMToken(String userId) {
        return mmTokenRepository.findByUserId(userId)
                .flatMap(token -> {
                    if (isTokenExpired(token)) {
                        return mmTokenRepository.delete(token)
                                .then(Mono.error(new CustomException("Mattermost 토큰이 만료되었습니다. 다시 로그인해주세요.", HttpStatus.UNAUTHORIZED)));
                    } else {
                        return Mono.just(token);
                    }
                })
                .switchIfEmpty(Mono.error(new CustomException("Mattermost 토큰이 없습니다.", HttpStatus.UNAUTHORIZED)));
    }

    private boolean isTokenExpired(MMToken token) {
        return LocalDateTime.now().isAfter(token.getExpiresAt());
    }
}
