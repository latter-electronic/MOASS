package com.moass.api.global.fcm.repository;


import com.moass.api.global.fcm.entity.FcmToken;
import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

public interface FcmRepository extends ReactiveCrudRepository<FcmToken, Integer> {

    Mono<FcmToken> findByUserIdAndMobileDeviceId(String userId, String mobileDeviceId);

    Mono<FcmToken> findByToken(String fcmToken);

    @Query("SELECT f.* FROM FcmToken f " +
            "INNER JOIN User u ON u.userId= f.userId " +
            "INNER JOIN SsafyUser su ON su.userId = u.userId "+
            "WHERE su.team_code = :teamCode")
    Flux<FcmToken> findAllByteamCode(String teamCode);

    @Query("SELECT token FROM FcmToken WHERE userId = :userId")
    Flux<String> findFcmTokensByUserId(String userId);

    @Query("SELECT * FROM FcmToken WHERE user_id = :userId AND token IS NOT NULL")
    Flux<FcmToken> findAllByUserId(String userId);
}