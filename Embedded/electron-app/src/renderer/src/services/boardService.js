import { moassApiAxios } from './apiConfig';
import AuthStore from '../stores/AuthStore.js';

const axios = moassApiAxios();
const prefix = 'api/board';

/**
 * 내가 접근 가능한 모든 방 조회
 * 
 * @returns {Promise} 방 목록 조회 결과
 */
export const fetchBoards = () => {
    const { accessToken } = AuthStore.getState();

    return axios.get(prefix, {
        headers: {
            'Authorization': `Bearer ${accessToken}`, 
            'Content-Type': 'application/json'
        }
    });
};

/**
 * 특정 board_user_id에 대한 스크린샷 목록 조회
 * 
 * @param {number} boardUserId
 * @returns {Promise} 스크린샷 목록 조회 결과
 */
export const fetchScreenshotsByBoardUserId = (boardUserId) => {
    const { accessToken } = AuthStore.getState();

    return axios.get(`${prefix}/${boardUserId}`, {
        headers: {
            'Authorization': `Bearer ${accessToken}`, 
            'Content-Type': 'application/json'
        }
    });
};

/**
 * 특정 방으로 접근 (접근 가능 여부 확인)
 * 
 * @param {number} boardId
 * @param {number} userId
 * @returns {Promise} 방 접근 결과
 */
export const accessRoom = (boardId, userId) => {
    const { accessToken } = AuthStore.getState();
    const url = `/room/${boardId}?userId=${userId}`;

    return axios.get(url, {
        headers: {
            'Authorization': `Bearer ${accessToken}`, 
            'Content-Type': 'application/json'
        }
    });
};

/**
 * 특정 스크린샷 조회
 * 
 * @param {number} screenshotId
 * @returns {Promise} 스크린샷 조회 결과
 */
export const fetchScreenshotById = (screenshotId) => {
    const { accessToken } = AuthStore.getState();

    return axios.get(`${prefix}/screenshot/${screenshotId}`, {
        headers: {
            'Authorization': `Bearer ${accessToken}`, 
            'Content-Type': 'application/json'
        }
    });
};

/**
 * 특정 스크린샷 삭제
 * 
 * @param {number} screenshotId
 * @returns {Promise} 스크린샷 삭제 결과
 */
export const deleteScreenshotById = (screenshotId) => {
    const { accessToken } = AuthStore.getState();

    return axios.delete(`${prefix}/screenshot/${screenshotId}`, {
        headers: {
            'Authorization': `Bearer ${accessToken}`, 
            'Content-Type': 'application/json'
        }
    });
};

/**
 * 보드 생성
 * 
 * @param {Object} boardData 보드 생성 데이터
 * @param {number} userId 사용자 ID
 * @returns {Promise} 보드 생성 결과
 */
export const createBoard = (userId) => {
    const { accessToken } = AuthStore.getState();
    const url = `/v1/board/create/${userId}`;

    return axios.get(url, {
        headers: {
            'Content-Type': 'application/json'
        }
    });
};