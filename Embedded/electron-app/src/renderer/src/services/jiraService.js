import { moassApiAxios } from './apiConfig.js';

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
 * @returns {Promise} 이슈 데이터
 */
export const fetchCurrentSprintIssues = async () => {
    const url = `${prefix}`;
    const fields = "creator,summary,priority,status,customfield_10031,parent";
    const jqlQuery = "project = 'S10P31E203' AND reporter = 'diduedidue@naver.com' AND sprint IN openSprints()";
    const maxResults = 240;

    const payload = {
        url: `/rest/api/3/search?jql=${jqlQuery}&fields=${fields}&maxResults=${maxResults}`,
        method: "get"
    };

    return axios.post(url, payload)
        .then(response => response.data)
        .catch(error => console.error('Error fetching current sprint issues:', error));
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
