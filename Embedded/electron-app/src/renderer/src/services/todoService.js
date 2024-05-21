import { moassApiAxios } from './apiConfig';
import AuthStore from '../stores/AuthStore.js';

const axios = moassApiAxios();
const prefix = 'api/schedule/todo';

/**
 * Todo 항목 가져오기
 * 
 * @returns {Promise} Todo 목록 조회 결과
 */
export const fetchTodos = () => {
    const { accessToken } = AuthStore.getState();  // Get the access token from AuthStore

    return axios.get(prefix, {
        headers: {
            'Authorization': `Bearer ${accessToken}`,  // Add the token to the request header
            'Content-Type': 'application/json'
        }
    });
};

/**
 * Todo 수정/완료 처리
 * 
 * @param {Object} updateData Todo 업데이트 데이터
 * @returns {Promise} Todo 수정 결과
 */
export const updateTodo = (updateData) => {
    const { accessToken } = AuthStore.getState();  // Get the access token from AuthStore

    return axios.patch(prefix, updateData, {
        headers: {
            'Authorization': `Bearer ${accessToken}`,  // Add the token to the request header
            'Content-Type': 'application/json'
        }
    });
};

/**
 * 특정 날짜의 에듀싸피 일정 가져오기
 * 
 * @param {string} date 조회할 날짜 (형식: YYYY-MM-DD)
 * @returns {Promise} 에듀싸피 일정 조회 결과
 */
export const fetchCurriculum = (date) => {
    const { accessToken } = AuthStore.getState();
    const url = `/api/schedule/curriculum/${date}`;

    return axios.get(url, {
        headers: {
            'Authorization': `Bearer ${accessToken}`,
            'Content-Type': 'application/json'
        }
    }).then(response => response.data)
    .catch(error => {
        console.error(`Error fetching curriculum for date ${date}:`, error);
        throw error;
    });
};