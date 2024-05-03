import { moassApiAxios } from './apiConfig.js';

const axios = moassApiAxios();
const API_URL = '/api/user';

/**
 * 사용자 정보 조회
 *
 * @returns {Promise} 사용자 정보 결과
 */
export const fetchUserInfo = () => {
    return axios.get(API_URL, {
        headers: {
            'Authorization': 'Bearer ~~~~~~~',
            'Content-Type': 'application/json'
        }
    });
};

/**
 * 액세스 토큰 갱신
 *
 * @returns {Promise} 갱신된 토큰 정보
 */
export const refreshToken = () => {
    return axios.post(`${API_URL}/refresh`, {}, {
        headers: {
            'Content-Type': 'application/json'
        }
    });
};