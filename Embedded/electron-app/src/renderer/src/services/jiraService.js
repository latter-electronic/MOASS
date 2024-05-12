import { moassApiAxios } from './apiConfig.js';
import AuthStore from '../stores/AuthStore.js'; 

import testDoneIssues from '../pages/jira/proxyTest/testJson10001.json' 

const axios = moassApiAxios();
const prefix = 'api/oauth2/jira/proxy';


/**
 * 현재 로그인한 사용자의 Jira 정보 조회
 * 
 * @returns {Promise} 사용자 정보
 */
export const getCurrentUser = async () => {
    const { accessToken } = AuthStore.getState();
    const payload = {
        method: "get",
        url: "/rest/api/3/myself",
    };

    return axios.post(prefix, payload, {
        headers: {
            'Authorization': `Bearer ${accessToken}`,
            'Content-Type': 'application/json'
        }
    }).then(response => {
        response.data
        console.log(response.data);
    })
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
    const { accessToken } = AuthStore.getState();
    const projectData = await getProject();
    const projectKey = projectData.values[0].key;
    const data = {
        method: "get",
        url: `/rest/api/3/search?jql=project = '${projectKey}' AND sprint IN openSprints() AND status = '${statusId}' AND reporter = 'diduedidue@naver.com'&fields=customfield_10014,summary,priority,assignee,customfield_10031&maxResults=240`
    };

    return axios.post(prefix, data, {
        headers: {
            'Authorization': `Bearer ${accessToken}`,
            'Content-Type': 'application/json'
        }
    }).then(response => response.data)
      .catch(error => {
          console.error('Error fetching current sprint issues based on status:', error);
          throw error;
      });
};

/**
 * 주어진 ID 또는 키로 Jira 이슈의 세부 정보 가져옴.
 * MOASS 내부에선 epic 가져오는 용도로 쓰임
 * 
 * @param {string} issueIdOrKey - 검색할 이슈의 ID 또는 키
 * @returns {Promise} 이슈 세부 정보를 나타내는 Promise 객체
 */
export const getIssueDetails = async (issueIdOrKey) => {
    const { accessToken } = AuthStore.getState();
    const data = {
        method: 'get',
        url: `/rest/api/3/issue/${issueIdOrKey}?fields=customfield_10011,customfield_10017`
    };

    return axios.post(prefix, data, {
        headers: {
            'Authorization': `Bearer ${accessToken}`,
            'Content-Type': 'application/json'
        }
    }).then(response => response.data)
      .catch(error => {
          console.error(`Error fetching details for issue ${issueIdOrKey}:`, error);
          throw error;
      });
};

/**
 * 최근 마감된 스프린트의 이슈들 검색
 * 
 * @returns {Promise} 이슈 데이터
 */
export const fetchRecentClosedSprintIssues = async () => {
    const { accessToken } = AuthStore.getState();
    const data = {
        method: "get",
        url: "/rest/api/3/search?jql=project = 'S10P31E203' AND reporter = 'diduedidue@naver.com' AND sprint IN closedSprints() AND sprint NOT IN futureSprints() ORDER BY sprint DESC&fields=creator,summary,priority,status,customfield_10031,parent&maxResults=50"
    };

    return axios.post(prefix, data, {
        headers: {
            'Authorization': `Bearer ${accessToken}`,
            'Content-Type': 'application/json'
        }
    }).then(response => response.data)
      .catch(error => {
          console.error('Error fetching recent closed sprint issues:', error);
          throw error;
      });
};

/**
 * 모든 Jira 프로젝트 검색
 * 
 * @returns {Promise} 프로젝트 목록
 * expand: insight  통해 lastIssueUpdatedTime 키값 json 결과값에 추가하고 해당 키를 통해 desc 정렬. 마지막 결과 1개만 받아옴
 */
export const getProject = async () => {
    const { accessToken } = AuthStore.getState();
    const data = {
        method: "get",
        url: "/rest/api/3/project/search?maxResults=1&expand=insight&orderBy=-lastIssueUpdatedTime"
    };

    return axios.post(prefix, data, {
        headers: {
            'Authorization': `Bearer ${accessToken}`,
            'Content-Type': 'application/json'
        }
    }).then(response => response.data)
      .catch(error => {
          console.error('Error fetching projects:', error);
          throw error;
      });
};

/**
 * 이슈를 새로운 상태로 전환하고 필요할 경우 전환 화면의 필드를 업데이트
 * 
 * @param {string} issueIdOrKey - 상태 전환을 수행할 이슈의 ID 또는 키
 * @param {object} transitionData - 전환 데이터
 * @returns {Promise} 요청의 결과를 반환하는 Promise 객체
 */
export const transitionIssue = async (issueIdOrKey, transitionData) => {
    const { accessToken } = AuthStore.getState();
    const payload = {
        method: 'post',
        url: `/rest/api/3/issue/${issueIdOrKey}/transitions`,
        body: JSON.stringify(transitionData)
    };

    return axios.post(`${prefix}`, payload, {
        headers: {
            'Authorization': `Bearer ${accessToken}`,
            'Content-Type': 'application/json'
        }
    })
    .then(response => response.data)
    .catch(error => {
        console.error(`Error transitioning issue ${issueIdOrKey}:`, error);
        throw error;
    });
};
