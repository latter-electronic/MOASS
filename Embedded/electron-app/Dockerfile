FROM ubuntu:latest

RUN sudo dpkg --add-architecture i386 \
    && sudo mkdir -pm755 /etc/apt/keyrings \
    && sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key \
    && sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/focal/winehq-focal.sources \
    && sudo apt update \
    && sudo apt install --install-recommends winehq-stable

# 기본 이미지 설정
FROM node:20.12.2 as builder

# 작업 디렉토리 설정
WORKDIR /app

# 애플리케이션 종속성 설치
COPY package.json package-lock.json ./
RUN npm install

# 소스 코드 복사
COPY . .

# RUN apt-get update && apt-get install -y --no-install-recommends \
#     wine \
#     && apt-get clean \
#     && rm -rf /var/lib/apt/lists/*

# 애플리케이션 빌드
RUN npm run build:pi

RUN npm run build:win
# RUN npm run build:mac

# # 애플리케이션 실행을 위한 런타임 이미지 설정
# FROM node:20.12.2-slim

# # 작업 디렉토리 설정
# WORKDIR /app

# # 필요한 파일 복사
# COPY --from=builder /app/dist ./dist
# COPY --from=builder /app/node_modules ./node_modules

# # 애플리케이션 실행
# CMD ["npm", "start"]
