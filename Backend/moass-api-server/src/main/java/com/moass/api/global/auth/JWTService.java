package com.moass.api.global.auth;

import com.moass.api.global.config.PropertiesConfig;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtBuilder;
import io.jsonwebtoken.JwtParser;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Date;

@Slf4j
@Component
@Service
public class JWTService {

    private final PropertiesConfig propertiesConfig;
    private final SecretKey accessKey;
    private final SecretKey refreshKey;

    private final JwtParser parser;
    private final JwtParser refreshparser;

    public JWTService(PropertiesConfig propertiesConfig) {
        this.propertiesConfig = propertiesConfig;
        this.accessKey = Keys.hmacShaKeyFor(propertiesConfig.getAccessKey().getBytes(StandardCharsets.UTF_8));
        this.refreshKey = Keys.hmacShaKeyFor(propertiesConfig.getRefreshKey().getBytes(StandardCharsets.UTF_8));
        this.parser = Jwts.parserBuilder().setSigningKey(this.accessKey).build();
        this.refreshparser = Jwts.parserBuilder().setSigningKey(this.refreshKey).build();
    }

    public String generate(String username){
        JwtBuilder builder = Jwts.builder()
                .setSubject(username)
                .setIssuedAt(Date.from(Instant.now()))
                .setExpiration(Date.from(Instant.now().plus(15, ChronoUnit.MINUTES)))
                .signWith(accessKey);

        return builder.compact();
    }

    public String getUserId(String token){
        Claims claims = parser.parseClaimsJws(token).getBody();
        return claims.getSubject();
    }

    public boolean validateAccessToken(String token) {
        try {
            Claims claims = parser.parseClaimsJws(token).getBody();
            return claims.getExpiration().after(new Date());
        } catch (Exception e) {
            log.info("엑세스 토큰 검증 실패");
            return false;
        }
    }
}
