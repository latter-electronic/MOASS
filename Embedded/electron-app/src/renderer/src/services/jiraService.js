import { moassApiAxios } from './apiConfig.js';

import testDoneIssues from '../pages/jira/proxyTest/testJson10001.json' 

const axios = moassApiAxios();
const prefix = '/api/oauth2/jira/proxy';


/**
 * 현재 로그인한 사용자의 Jira 정보 조회
 * 
 * @returns {Promise} 사용자 정보
 */
export const getCurrentUser = async () => {
    const url = `${prefix}`;
    const payload = {
        url: '/rest/api/3/myself',
        method: "get"
    };

    return axios.post(url, payload)
        .then(response => response.data)
        .catch(error => {
            console.error('Error fetching current user details:', error);
            throw error;
        });
};


/**
 * 현재 열려있는 스프린트의 이슈들 검색
 * 
 * @param {string} statusId - 조회할 이슈의 상태 ID ('10000' - 해야 할 일, '3' - 진행 중, '10001' - 완료)
 * @returns {Promise} 이슈 데이터
 */
export const fetchCurrentSprintIssues = async (statusId) => {
    try {
        const projectData = await getProject();
        const projectKey = projectData.values[0].key; // 가장 최근에 업데이트된 프로젝트의 키

        const url = `${prefix}`;
        const fields = "customfield_10014, summary, priority, assignee, customfield_10031";
        const jqlQuery = `project = '${projectKey}' AND sprint IN openSprints() AND status = '${statusId}' AND reporter = 'diduedidue@naver.com'`; // 잠시 개발용으로
        const maxResults = 240;

        const payload = {
            url: `/rest/api/3/search?jql=${jqlQuery}&fields=${fields}&maxResults=${maxResults}`,
            method: "get"
        };

        return axios.post(url, payload)
            .then(response => response.data)
            .catch(error => console.error('Error fetching current sprint issues based on status:', error));
    } catch (error) {
        console.error('Failed to fetch project key:', error);
        throw error;
    }
};

/**
 * 주어진 ID 또는 키로 Jira 이슈의 세부 정보 가져옴.
 * MOASS 내부에선 epic 가져오는 용도로 쓰임
 * 
 * @param {string} issueIdOrKey - 검색할 이슈의 ID 또는 키
 * @returns {Promise} 이슈 세부 정보를 나타내는 Promise 객체
 */
export const getIssueDetails = async (issueIdOrKey) => {
    const url = `${prefix}`;
    const fields = 'customfield_10011, customfield_10017'  // 10011 에픽이름, 10017 색상
    const payload = {
        url: `/rest/api/3/issue/${issueIdOrKey}?fields=${fields}`,
        method: "get"
    };

    return axios.post(url, payload)
        .then(response => response.data)
        .catch(error => {
            console.error(`이슈 ${issueIdOrKey}의 세부 정보를 가져오는 중 오류 발생:`, error);
            throw error;
        });
};

/**
 * 최근 마감된 스프린트의 이슈들 검색
 * 
 * @returns {Promise} 이슈 데이터
 */
export const fetchRecentClosedSprintIssues = async () => {
    const url = `${prefix}`;
    const fields = 'creator,summary,priority,status, customfield_10031, parent';
    const jqlQuery = "project = 'S10P31E203' AND reporter = 'diduedidue@naver.com' AND sprint IN closedSprints() AND sprint NOT IN futureSprints() ORDER BY sprint DESC";
    const maxResults = 50;  // 일단 50

    const payload = {
        url: `/rest/api/3/search?jql=${jqlQuery}&fields=${fields}&maxResults=${maxResults}`,
        method: "get"
    };

    return axios.post(url, payload)
        .then(response => response.data)
        .catch(error => console.error('Error fetching recent closed sprint issues:', error));
};

/**
 * 모든 Jira 프로젝트 검색
 * 
 * @returns {Promise} 프로젝트 목록
 * expand: insight  통해 lastIssueUpdatedTime 키값 json 결과값에 추가하고 해당 키를 통해 desc 정렬. 마지막 결과 1개만 받아옴
 */
export const getProject = async () => {
    const url = `${prefix}`;
    const maxResults = 1
    const expand = 'insight'
    const orderBy ='-lastIssueUpdatedTime'

    const payload = {
        url: `/rest/api/3/project/search?maxResults=${maxResults}&expand=${expand}&orderBy=${orderBy}`,
        method: "get"
    };

    return axios.post(url, payload)
        .then(response => response.data)
        .catch(error => console.error('Error fetching projects:', error));
};
