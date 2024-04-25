# 기본 이미지 설정
FROM node:20 as builder

# 작업 디렉토리 설정
WORKDIR /app

# 애플리케이션 종속성 설치
COPY package.json package-lock.json ./
RUN npm install

# 소스 코드 복사
COPY . .

# 애플리케이션 빌드
RUN npm run build:pi
RUN npm run build:win
RUN npm run build:mac

# 애플리케이션 실행을 위한 런타임 이미지 설정
FROM node:20-slim

# 작업 디렉토리 설정
WORKDIR /app

# 필요한 파일 복사
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules

# 애플리케이션 실행
CMD ["npm", "start"]
