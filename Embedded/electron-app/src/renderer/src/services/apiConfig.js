import axios from "axios";
import AuthStore from '../stores/AuthStore.js';

const MOASS_API_URL = "https://k10e203.p.ssafy.io";
const MOZZY_LUNCH_URL = "https://ssafyfood-www-jong.koyeb.app";

async function refreshAccessToken() {
    const { refreshToken } = AuthStore.getState();
    const response = await axios.post(`${MOASS_API_URL}/api/user/refresh`, {}, {
        headers: {
            'Authorization': `Bearer ${refreshToken}`
        }
    });

    const { accessToken } = response.data.data;
    AuthStore.getState().login(accessToken, refreshToken, AuthStore.getState().deviceId, AuthStore.getState().cardSerialId);
    return accessToken;
}

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
            const { logout } = AuthStore.getState();

            if (error.response && error.response.status === 401 && !originalRequest._retry) {
                originalRequest._retry = true;

                try {
                    const newAccessToken = await refreshAccessToken();
                    originalRequest.headers.Authorization = `Bearer ${newAccessToken}`;
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
