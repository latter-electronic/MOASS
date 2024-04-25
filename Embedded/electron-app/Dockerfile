# # 기본 이미지 설정
# FROM node:20.12.2 as builder

# # 작업 디렉토리 설정
# WORKDIR /app

# # 애플리케이션 종속성 설치
# COPY package.json package-lock.json ./
# RUN npm install

# # 소스 코드 복사
# COPY . .

# RUN apt-get update && apt-get install -y --no-install-recommends \
#     wine \
#     && apt-get clean \
#     && rm -rf /var/lib/apt/lists/*

# # 애플리케이션 빌드
# RUN npm run build:pi

# RUN npm run build:win
# # RUN npm run build:mac

# 기본 이미지 선택
FROM ubuntu:20.04

# Cross-compilation 도구 설치
RUN apt-get update && apt-get install -y --no-install-recommends \
    mingw-w64 \
    && rm -rf /var/lib/apt/lists/*

# Electron 및 빌드 의존성 설치
# 예시로 Node.js와 npm을 설치합니다. 실제 프로젝트에 필요한 의존성을 설치하세요.
RUN apt-get update && apt-get install -y --no-install-recommends \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

# 작업 디렉토리 설정
WORKDIR /app

# 애플리케이션 소스 코드 복사
COPY . .

# 빌드 스크립트 실행
RUN npm install
RUN npm run build:win

# 애플리케이션 실행을 위한 런타임 이미지 설정
FROM node:20.12.2-slim

# 작업 디렉토리 설정
WORKDIR /app

# 필요한 파일 복사
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules

# 애플리케이션 실행
CMD ["npm", "start"]
