# 기본 이미지를 선택
FROM ubuntu:20.04.6

# 환경 변수 설정
ENV FLUTTER_VERSION=3.19.6
ENV PATH="${PATH}:/flutter/bin"

# 필수 패키지 설치
RUN apt-get update && \
    apt-get install -y \
    git \
    unzip \
    curl \
    xz-utils \
    libglu1-mesa

# Flutter SDK 다운로드 및 설치
RUN curl -O https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz && \
    tar xf flutter_linux_${FLUTTER_VERSION}-stable.tar.xz && \
    rm flutter_linux_${FLUTTER_VERSION}-stable.tar.xz && \
    flutter doctor

# Flutter 의존성 설치
RUN flutter doctor

# 작업 디렉토리 생성 및 앱 소스코드 복사
WORKDIR /app
COPY . .

# 앱 의존성 설치
RUN flutter pub get

# 앱 빌드
RUN flutter build web

# 빌드된 앱 파일을 Nginx의 디렉토리로 이동
RUN mv build/web/* /var/www/html/

# 80 포트 오픈 (만약 포트가 이미 열려있다면 생략 가능)
EXPOSE 80

# Nginx 실행 (만약 호스트 시스템에서 이미 실행 중이라면 생략 가능)
CMD ["nginx", "-g", "daemon off;"]