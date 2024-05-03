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
