package com.moass.api.global.auth;

import com.moass.api.global.auth.dto.Tokens;
import com.moass.api.global.auth.dto.UserInfo;
import com.moass.api.global.config.PropertiesConfig;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtBuilder;
import io.jsonwebtoken.JwtParser;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;
import reactor.core.scheduler.Schedulers;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Slf4j
@Component
@Service
public class JWTService {

    private final PropertiesConfig propertiesConfig;
    private final SecretKey accessKey;
    private final SecretKey refreshKey;

    private final JwtParser accessParser;
    private final JwtParser refreshParser;

    public JWTService(PropertiesConfig propertiesConfig) {
        this.propertiesConfig = propertiesConfig;
        this.accessKey = Keys.hmacShaKeyFor(propertiesConfig.getAccessKey().getBytes(StandardCharsets.UTF_8));
        this.refreshKey = Keys.hmacShaKeyFor(propertiesConfig.getRefreshKey().getBytes(StandardCharsets.UTF_8));
        this.accessParser = Jwts.parserBuilder().setSigningKey(this.accessKey).build();
        this.refreshParser = Jwts.parserBuilder().setSigningKey(this.refreshKey).build();
    }

    public Mono<Tokens> generateTokens(UserInfo userInfo) {
        return Mono.fromCallable(() -> {
            Instant now = Instant.now();
            Date nowDate = Date.from(now);
            Date expirationDateForAccessToken = Date.from(now.plus(3, ChronoUnit.HOURS));
            Date expirationDateForRefreshToken = Date.from(now.plus(7, ChronoUnit.DAYS));

            String accessToken = Jwts.builder()
                    .setSubject(userInfo.getUserId())
                    .claim("userEmail", userInfo.getUserEmail())
                    .claim("userId", userInfo.getUserId())
                    .claim("userName", userInfo.getUserName())
                    .claim("jobCode", userInfo.getJobCode())
                    .claim("teamCode", userInfo.getTeamCode())
                    .setIssuedAt(nowDate)
                    .setExpiration(expirationDateForAccessToken)
                    .signWith(this.accessKey)
                    .compact();

            String refreshToken = Jwts.builder()
                    .setSubject(userInfo.getUserId())
                    .claim("userEmail", userInfo.getUserEmail())
                    .claim("userId", userInfo.getUserId())
                    .claim("userName", userInfo.getUserName())
                    .claim("jobCode", userInfo.getJobCode())
                    .claim("teamCode", userInfo.getTeamCode())
                    .setIssuedAt(nowDate)
                    .setExpiration(expirationDateForRefreshToken)
                    .signWith(this.refreshKey)
                    .compact();

            Tokens tokens = new Tokens();
            tokens.setAccessToken(accessToken);
            tokens.setRefreshToken(refreshToken);
            return tokens;
        }).subscribeOn(Schedulers.boundedElastic());
    }


    public UserInfo getUserInfoFromAccessToken(String token) {
        Claims claims = accessParser.parseClaimsJws(token).getBody();
        return new UserInfo(claims.get("userId", String.class),
                claims.get("userName", String.class),
                claims.get("userEmail", String.class),
                claims.get("jobCode", Integer.class),
                claims.get("teamCode",String.class));
    }

    public UserInfo getUserInfoFromRefreshToken(String token) {
        Claims claims = refreshParser.parseClaimsJws(token).getBody();
        return new UserInfo(claims.get("userId", String.class),
                claims.get("userName", String.class),
                claims.get("userEmail", String.class),
                claims.get("jobCode", Integer.class),
        claims.get("teamCode",String.class));
    }

    public boolean validateAccessToken(String token) {
        try {
            Claims claims = accessParser.parseClaimsJws(token).getBody();
            return claims.getExpiration().after(new Date());
        } catch (Exception e) {
            log.info("액세스 토큰 검증 실패");
            return false;
        }
    }

    public boolean validateRefreshToken(String token) {
        try {
            Claims claims = refreshParser.parseClaimsJws(token).getBody();
            return claims.getExpiration().after(new Date());
        } catch (Exception e) {
            log.info("리프레쉬 토큰 검증 실패");
            return false;
        }
    }
}
