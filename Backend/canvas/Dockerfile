# 베이스 이미지로 Node.js를 사용합니다.
FROM node:16-alpine

# 작업 디렉토리를 설정합니다.
WORKDIR /app

# 소스 코드를 복사합니다.
COPY . .

# TypeScript와 ts-node를 설치합니다.
RUN npm install -g typescript ts-node

# 종속성을 설치합니다.
RUN npm install

# 타입스크립트 코드를 실행합니다.
CMD npm start