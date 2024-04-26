# macOS용 Electron 빌드를 위한 이미지
FROM electronuserland/builder:latest as macos-builder

# 작업 디렉토리 설정
WORKDIR /app

# 필요한 파일 복사
COPY . .

# 필요한 패키지 설치 및 빌드 실행
RUN npm install && electron-builder --mac