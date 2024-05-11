import { jiraApiAxios } from './apiConfig.js';

const axios = moassApiAxios();
const prefix = '';

/**
 * 현재 열려있는 스프린트의 이슈들 검색
 * 
 * @returns {Promise} 이슈 데이터
 */
export const fetchCurrentSprintIssues = async () => {
    const jqlQuery = "project = 'S10P31E203' AND reporter = 'diduedidue@naver.com' AND sprint IN openSprints()";
    const fields = "creator,summary,priority,status,customfield_10031,parent";
    const maxResults = 240;
    const url = `/api/oauth2/jira/proxy`;

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
    const fields = 'creator,summary,priority,status, customfield_10031, parent';
    const jqlQuery = "project = 'S10P31E203' AND reporter = 'diduedidue@naver.com' AND sprint IN closedSprints() AND sprint NOT IN futureSprints() ORDER BY sprint DESC";
    const maxResults = 50;  // 일단 50
    const url = `/api/oauth2/jira/proxy`;

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
 */
export const fetchProjects = async () => {
    const url = `/api/oauth2/jira/proxy`;
    const payload = {
        url: '/rest/api/3/project/search',
        method: "get"
    };

    return axios.post(url, payload)
        .then(response => response.data)
        .catch(error => console.error('Error fetching projects:', error));
};
