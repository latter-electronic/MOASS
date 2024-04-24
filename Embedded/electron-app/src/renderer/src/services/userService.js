import { moassApiAxios } from './apiConfig.js';

// 기본 사용자 관련 API 경로
const API_URL = '/api/user';

// 사용자 로그인
export const login = credentials => moassApiAxios().post(`${API_URL}/login`, credentials);

// 사용자 회원가입
export const signUp = userData => moassApiAxios().post(`${API_URL}/signup`, userData);

// 엑세스 토큰 갱신
export const refreshToken = () => moassApiAxios().post(`${API_URL}/refresh`);

// 사용자 정보 수정
export const updateUser = (userId, updateData) => moassApiAxios().patch(`${API_URL}/${userId}`, updateData);

// 사용자 상태 수정
export const updateStatus = (userId, statusData) => moassApiAxios().post(`${API_URL}/${userId}/status`, statusData);

// 사용자 로그아웃
export const logout = () => moassApiAxios().post(`${API_URL}/logout`);

// 모든 사용자 조회
export const fetchAllUsers = () => moassApiAxios().get(`${API_URL}/alluser`);

// 내 팀 조회
export const fetchMyTeam = () => moassApiAxios().get(`${API_URL}/team`);

// 관리자 권한으로 사용자 정보 수정
export const adminUpdateUser = (studentId, updateData) => moassApiAxios().patch(`${API_URL}/${studentId}`, updateData);

// 사용자 삭제
export const deleteUser = userId => moassApiAxios().delete(`${API_URL}/${userId}`);

// 관리자 권한으로 새 사용자 등록
export const adminCreateUser = userData => moassApiAxios().post(`${API_URL}/create`, userData);
