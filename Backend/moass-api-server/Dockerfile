# 첫 번째 스테이지: Gradle 빌드
FROM gradle:8.6 AS builder

# 작업 디렉토리 설정
WORKDIR /home/gradle/project

# Gradle 빌드에 필요한 파일 복사
COPY build.gradle .
COPY settings.gradle .
# COPY gradle.properties .
COPY src src

# 의존성 다운로드 및 애플리케이션 빌드
RUN gradle build --no-daemon -x test

# 두 번째 스테이지: 빌드된 JAR를 실행할 OpenJDK 기반의 JRE 이미지
FROM openjdk:17-alpine

ENV JAVA_OPTS "-XX:+AllowRedefinitionToAddDeleteMethods"

# 작업 디렉토리 설정
WORKDIR /app

# 첫 번째 스테이지에서 빌드된 JAR를 두 번째 스테이지로 복사
COPY --from=builder /home/gradle/project/build/libs/*.jar app.jar

# 애플리케이션 실행
ENTRYPOINT ["sh", "-c", "java ${JAVA_OPTS} -jar -Dspring.profiles.active=prod app.jar"]
