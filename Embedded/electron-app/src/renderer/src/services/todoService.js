import { moassApiAxios } from './apiConfig';

const axios = moassApiAxios();
const prefix = 'api/schedule/todo';

/**
 * Todo 항목 가져오기
 * 
 * @returns {Promise} Todo 목록 조회 결과
 */
export const fetchTodos = () => {
    return axios.get(prefix);
};

/**
 * Todo 수정/완료 처리
 * 
 * @param {Object} updateData Todo 업데이트 데이터
 * @returns {Promise} Todo 수정 결과
 */
export const updateTodo = (updateData) => {
    return axios.patch(prefix, updateData, {
        headers: { 'Content-Type': 'application/json' }
    });
};