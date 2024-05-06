// jiraService.js
import { jiraApiAxios } from './apiConfig';

const axios = jiraApiAxios();
const prefix = 'rest/api/3';

/**
 * 현재 열려있는 스프린트의 이슈들 검색
 * 
 * @returns {Promise} 이슈 데이터
 */
export const fetchCurrentSprintIssues = async () => {
    const fields = 'creator,summary,priority,status';
    const jqlQuery = encodeURIComponent("project = 'S10P31E203' AND sprint IN openSprints()");
    const url = `${prefix}/search?jql=${jqlQuery}&fields=${fields}&maxResults=10`;

    return axios.get(url)
        .then(response => response.data)
        .catch(error => {
            console.error('Error fetching current sprint issues:', error);
        });
};

/**
 * 최근 마감된 스프린트의 이슈들 검색
 * 
 * @returns {Promise} 이슈 데이터
 */
export const fetchRecentClosedSprintIssues = async () => {
    const fields = 'creator,summary,priority,status';
    const jqlQuery = encodeURIComponent("project = 'S10P31E203' AND reporter = 'diduedidue@naver.com' AND sprint IN closedSprints() AND sprint NOT IN futureSprints() ORDER BY sprint DESC");
    const maxResults = 50;  // 일단 50
    const url = `${prefix}/search?jql=${jqlQuery}&fields=${fields}&maxResults=${maxResults}`;

    return axios.get(url)
        .then(response => response.data)
        .catch(error => {
            console.error('Error fetching recent closed sprint issues:', error);
        });
};

/**
 * 모든 Jira 프로젝트 검색
 * 
 * @returns {Promise} 프로젝트 목록
 */
export const fetchProjects = () => {
    return axios.get(`${prefix}/project/search`)
        .then(response => response.data)
        .catch(error => {
            console.error('Error fetching projects:', error);
        });
};
