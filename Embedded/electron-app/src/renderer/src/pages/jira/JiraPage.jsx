import { useEffect, useState } from 'react';
import IssueCard from './JiraIssueCard.jsx';
import testIssue from './test/recentClosedSprintIssues.json'
import dropdownArrow from '../../assets/images/jira/dropdown-arrow.svg';
import profile1 from '../../assets/images/jira/jiraProfileImg1.png'
import profile2 from '../../assets/images/jira/jiraProfileImg2.png'
import profile3 from '../../assets/images/jira/jiraProfileImg3.png'
import profile4 from '../../assets/images/jira/jiraProfileImg4.png'
import profile5 from '../../assets/images/jira/jiraProfileImg5.png'
import profile6 from '../../assets/images/jira/jiraProfileImg6.png'
import { fetchRecentClosedSprintIssues } from '../../services/jiraService';

const profileImages = [profile1, profile2, profile3, profile4, profile5, profile6];

export default function JiraPage() {
    const [issues, setIssues] = useState([]);

    useEffect(() => {
        fetchRecentClosedSprintIssues().then(data => {
            setIssues(data.issues);
            console.log(issues)
        }).catch(error => {
            console.error('Failed to fetch issues:', error);
            setIssues(testIssue.issues);
        });
    });

    return (
        <div className=" mx-auto p-6 h-screen overflow-hidden">
            <div className="flex items-center text-white font-extrabold text-3xl mb-5">
                <div>S10P31E203 보드</div>

                <img src={dropdownArrow} alt="화살표" className="ml-2" />
                <div className="flex -space-x-2 ml-4">
                    {profileImages.map((avatar, index) => (
                        <img key={index} src={avatar} alt={`participant ${index + 1}`} className="size-10 rounded-full border-2 ml-6 border-black shadow-sm" />
                    ))}
                </div>

            </div>
            <div className="grid grid-cols-3 gap-5 h-full w-[88vw] ml-4">

                {/* 해야 할 일 */}
                <div className="flex flex-col">
                    <div className="bg-white/10 p-3 rounded-lg flex-1">
                        <h3 className="text-white/70 text-lg ml-1 font-light mb-4">해야 할 일</h3>
                        <div className="mt-2">
                            {/* <IssueCard />
                            <IssueCard />
                            <IssueCard /> */}
                        </div>
                    </div>
                </div>

                {/* 진행 중 */}
                <div className="flex flex-col">
                    <div className="bg-white/10 p-3 rounded-lg flex-1">
                        <h3 className="text-white/70 text-lg ml-1 font-light">진행 중</h3>
                        {/* Place for current tasks */}
                    </div>
                </div>

                {/* 완료 */}
                <div className="flex flex-col">
                    <div className="bg-white/10 p-3 rounded-lg flex-1">
                        <h3 className="text-white/70 text-lg ml-1 font-light">완료</h3>
                        {issues.map(issue => (
                            <IssueCard key={issue.id} issue={issue} />
                        ))}
                    </div>
                </div>

            </div>
        </div>
    );
}
