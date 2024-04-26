# Windows용 Electron 빌드를 위한 이미지
FROM electronuserland/builder:wine as windows-builder

# 작업 디렉토리 설정
WORKDIR /app

# 필요한 파일 복사
COPY . .

# Windows용 Electron 빌드 실행
RUN electron-builder --win

# macOS용 Electron 빌드를 위한 이미지
FROM electronuserland/builder:latest as macos-builder

# 작업 디렉토리 설정
WORKDIR /app

# 필요한 파일 복사
COPY . .

# macOS용 Electron 빌드 실행
RUN electron-builder --mac