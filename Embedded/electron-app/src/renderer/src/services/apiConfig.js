import axios from "axios";
import AuthStore from '../stores/AuthStore.js';
import { refreshAccessToken } from './userService.js';

let isRefreshing = false;
let failedQueue = [];

const processQueue = (error, token = null) => {
    failedQueue.forEach(prom => {
        if (error) {
            prom.reject(error);
        } else {
            prom.resolve(token);
        }
    });
    failedQueue = [];
};

export function moassApiAxios() {
    const MOASS_API_URL = "https://k10e203.p.ssafy.io";
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
            const { logout, login, refreshToken } = AuthStore.getState();

            if (error.response && error.response.status === 401 && !originalRequest._retry) {
                if (isRefreshing) {
                    return new Promise((resolve, reject) => {
                        failedQueue.push({ resolve, reject });
                    }).then(token => {
                        originalRequest.headers.Authorization = `Bearer ${token}`;
                        return axios(originalRequest);
                    }).catch(err => {
                        return Promise.reject(err);
                    });
                }

                originalRequest._retry = true;
                isRefreshing = true;

                try {
                    const newAccessToken = await refreshAccessToken();
                    login(newAccessToken, refreshToken, AuthStore.getState().deviceId, AuthStore.getState().cardSerialId);
                    processQueue(null, newAccessToken);
                    originalRequest.headers.Authorization = `Bearer ${newAccessToken}`;
                    return axios(originalRequest);
                } catch (err) {
                    processQueue(err, null);
                    logout(); // refresh token 갱신 실패 시 로그아웃 처리
                    return Promise.reject(err);
                } finally {
                    isRefreshing = false;
                }
            }

            return Promise.reject(error);
        }
    );

    return instance;
}

export function mozzyLunchApiAxios() {
    const MOZZY_LUNCH_URL = "https://ssafyfood-www-jong.koyeb.app";
    return axios.create({
        baseURL: MOZZY_LUNCH_URL,
    });
}
