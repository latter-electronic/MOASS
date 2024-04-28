import IssueIcon from '../../assets/images/jira/jiraIssueIcon.svg'
import profileImg from '../../assets/images/jira/jiraProfileImg1.png'
import highestIcon from '../../assets/images/jira/p-highest.svg'
import highIcon from '../../assets/images/jira/p-high.svg'
import mediumIcon from '../../assets/images/jira/p-medium.svg'
import lowIcon from '../../assets/images/jira/p-low.svg'
import lowestIcon from '../../assets/images/jira/p-low.svg'

export default function JiraIssueCard() {
    return (
        <div className="flex flex-col mt-2 bg-white rounded-lg shadow p-3 px-5 gap-1">

            <div className="font-medium text-gray-700">Electron 개발 초기 환경 테스트</div>
            
            <div className="flex justify-between items-center">
                <div className="flex items-center gap-2">
                    <img src={IssueIcon} alt="jira issue icon" className="w-6 h-6" />
                    <span className="bg-emerald-200 text-emerald-900 text-sm px-2 py-1 rounded">[EM] 임베디드 공통</span>
                </div>
                <div className="flex items-center gap-2 mt-1">
                    <span className="bg-gray-200 rounded-full text-xs font-semibold px-2 py-1 text-gray-700">2</span>
                    <img src={mediumIcon} alt="중간중요도" className="size-5"/>
                    <img src={profileImg} alt="지라프로필1" className="rounded-full w-9 h-9" />
                </div>
            </div>

        </div>
    );
}
