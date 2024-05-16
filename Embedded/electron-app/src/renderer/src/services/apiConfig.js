import axios from "axios";
import AuthStore from '../stores/AuthStore.js';
import { refreshAccessToken } from './userService.js';

const MOASS_API_URL = "https://k10e203.p.ssafy.io";
const MOZZY_LUNCH_URL = "https://ssafyfood-www-jong.koyeb.app";

export function moassApiAxios() {
    const instance = axios.create({
        baseURL: MOASS_API_URL,
        withCredentials: true,
        params: {
            "language": "ko-KR"
        },
    });

    instance.interceptors.request.use(
        (config) => {
            const { accessToken } = AuthStore.getState();
            if (accessToken) {
                config.headers.Authorization = `Bearer ${accessToken}`;
            }
            return config;
        },
        (error) => {
            return Promise.reject(error);
        }
    );

    instance.interceptors.response.use(
        (response) => {
            return response;
        },
        async (error) => {
            const originalRequest = error.config;
            const { refreshToken, logout, login } = AuthStore.getState();

            if (error.response && error.response.status === 401 && !originalRequest._retry) {
                originalRequest._retry = true;

                try {
                    const response = await refreshAccessToken();
                    const { accessToken, refreshToken } = response.data.data;
                    login(accessToken, refreshToken, AuthStore.getState().deviceId, AuthStore.getState().cardSerialId); // 새로 발급받은 토큰을 저장

                    originalRequest.headers.Authorization = `Bearer ${accessToken}`;
                    return axios(originalRequest);
                } catch (err) {
                    logout(); // refresh token 갱신 실패 시 로그아웃 처리
                    return Promise.reject(err);
                }
            }

            return Promise.reject(error);
        }
    );

    return instance;
}

export function mozzyLunchApiAxios() {
    return axios.create({
        baseURL: MOZZY_LUNCH_URL,
    });
}
