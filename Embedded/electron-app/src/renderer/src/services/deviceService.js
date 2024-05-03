import { moassApiAxios } from './apiConfig';
import AuthStore from '../stores/AuthStore.js';

const axios = moassApiAxios();
const prefix = 'api/device';

/**
 * 기기 로그인
 * 
 * @param {Object} loginData 로그인 데이터
 * @returns {Promise} 로그인 결과
 */
export const deviceLogin = (loginData) => {
    return axios.post(`${prefix}/login`, loginData, {
        headers: { 'Content-Type': 'application/json' }
    });
};

/**
 * 기기 로그아웃
 * 
 * @returns {Promise} 로그아웃 결과
 */
export const deviceLogout = () => {
    console.log(moassApiAxios)
    return axios.post(`${prefix}/logout`);
};

/**
 * 기기 정보 조회
 * 
 * @returns {Promise} 기기 정보
 */
export const fetchDeviceInfo = () => {
    return axios.get(prefix);
};

/**
 * 기기 호출
 * 
 * @param {string} studentId 학생 ID
 * @returns {Promise} 호출 결과
 */
export const callDevice = (studentId) => {
    return axios.post(`${prefix}/call`, { studentId }, {
        headers: { 'Content-Type': 'application/json' }
    });
};
