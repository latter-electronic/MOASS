# 베이스 이미지 설정
FROM node:20.12.2 AS builder

# 작업 디렉토리 생성 및 설정
WORKDIR /app

# 필요한 파일 복사
COPY . .

# 애플리케이션 의존성 설치
RUN npm install

# 애플리케이션 빌드
RUN npm run build:pi