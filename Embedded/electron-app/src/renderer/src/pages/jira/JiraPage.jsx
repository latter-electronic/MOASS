import { useEffect, useState } from 'react';
import IssueCard from './JiraIssueCard.jsx';
import dropdownArrow from '../../assets/images/jira/dropdown-arrow.svg';
import profile1 from '../../assets/images/jira/jiraProfileImg1.png'
import profile2 from '../../assets/images/jira/jiraProfileImg2.png'
import profile3 from '../../assets/images/jira/jiraProfileImg3.png'
import profile4 from '../../assets/images/jira/jiraProfileImg4.png'
import profile5 from '../../assets/images/jira/jiraProfileImg5.png'
import profile6 from '../../assets/images/jira/jiraProfileImg6.png'
import { fetchCurrentSprintIssues } from '../../services/jiraService.js';

import testDoneIssues from './proxyTest/testJson10001.json'

const profileImages = [profile1, profile2, profile3, profile4, profile5, profile6];

export default function JiraPage() {
    const [todoIssues, setTodoIssues] = useState([]);
    const [inProgressIssues, setInProgressIssues] = useState([]);
    const [doneIssues, setDoneIssues] = useState([]);
    const [loadingTodo, setLoadingTodo] = useState(true);
    const [loadingInProgress, setLoadingInProgress] = useState(true);
    const [loadingDone, setLoadingDone] = useState(false);

    useEffect(() => {
        async function fetchIssues(statusId, setIssues, setLoading) {
            try {
                const data = await fetchCurrentSprintIssues(statusId);
                setIssues(data.issues);
            } catch (error) {
                console.error('Error fetching issues:', error);
            }
            setLoading(false);
        }

        fetchIssues('10000', setTodoIssues, setLoadingTodo); // "해야 할 일"
        fetchIssues('3', setInProgressIssues, setLoadingInProgress); // "진행 중"
        // fetchIssues('10001', setDoneIssues, setLoadingDone); // "완료"
        setDoneIssues(testDoneIssues.issues); // "완료"
    }, []);

    const renderLoading = () => (
        <div className="flex justify-center items-center h-full">
            <div className="text-lg text-white/30 font-normal">로딩 중...</div>
        </div>
    );

    const renderNoIssuesMessage = () => (
        <div className="flex justify-center items-center h-full">
            <div className="text-2xl text-white/10 font-normal mb-6">해당 상태의 이슈가 없어요</div>
        </div>
    );

    return (
        <div className="mx-auto p-6 h-screen overflow-hidden">
            <div className="flex items-center text-white font-extrabold text-3xl mb-5">
                <div>S10P31E203 보드</div>
                <img src={dropdownArrow} alt="화살표" className="ml-2" />
                <div className="flex -space-x-2 ml-4">
                    {profileImages.map((avatar, index) => (
                        <img key={index} src={avatar} alt={`participant ${index + 1}`} className="w-10 h-10 rounded-full border-2 border-black shadow-sm" />
                    ))}
                </div>
            </div>

            <div className="grid grid-cols-3 gap-5 h-full w-[88vw] ml-4">
                {/* 해야 할 일 */}
                <div className="flex flex-col bg-white/10 p-3 rounded-lg flex-1">
                    <h3 className="text-white/70 text-lg ml-1 font-light mb-4">해야 할 일</h3>
                    <div className="h-[76vh] overflow-auto scrollbar-hide">
                        {loadingTodo ? renderLoading() : todoIssues.length ? todoIssues.map(issue => <IssueCard key={issue.id} issue={issue} />) : renderNoIssuesMessage()}
                    </div>
                </div>

                {/* 진행 중 */}
                <div className="flex flex-col bg-white/10 p-3 rounded-lg flex-1">
                    <h3 className="text-white/70 text-lg ml-1 font-light mb-4">진행 중</h3>
                    <div className="h-[76vh] overflow-auto scrollbar-hide">
                        {loadingInProgress ? renderLoading() : inProgressIssues.length ? inProgressIssues.map(issue => <IssueCard key={issue.id} issue={issue} />) : renderNoIssuesMessage()}
                    </div>
                </div>

                {/* 완료 */}
                <div className="flex flex-col bg-white/10 p-3 rounded-lg flex-1">
                    <h3 className="text-white/70 text-lg ml-1 font-light mb-4">완료</h3>
                    <div className="h-[76vh] overflow-auto scrollbar-hide">
                        {loadingDone ? renderLoading() : doneIssues.length ? doneIssues.map(issue => <IssueCard key={issue.id} issue={issue} />) : renderNoIssuesMessage()}
                    </div>
                </div>
            </div>
        </div>
    );
}
