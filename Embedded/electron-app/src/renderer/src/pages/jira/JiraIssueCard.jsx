import IssueIcon from '../../assets/images/jira/jiraIssueIcon.svg'
import { getEpicColorClasses } from '../../utils/colorUtils.js';

export default function JiraIssueCard({ issue }) {
    const { summary, creator, priority, status, parent } = issue.fields;
    const { text, bg } = getEpicColorClasses(parent.fields.summary);

    return (
        <div className="flex flex-col mt-2 bg-white rounded-lg shadow p-3 px-5 gap-1 text-base">

            <div className="font-medium text-lg text-gray-700">{summary}</div>
            
            <div className="flex justify-between items-center">
                <div className="flex items-center gap-2">
                    <img src={IssueIcon} alt="jira issue icon" className="w-6 h-6" />
                    <span className={`${text} ${bg} px-2 py-1 rounded font-semibold`}>{parent.fields.summary}</span>
                </div>
                <div className="flex items-center gap-2 mt-1">
                    <span className="bg-gray-200 rounded-full text-sm font-semibold px-2 py-1 text-gray-700">2</span>
                    <img src={priority.iconUrl} alt="중요도 아이콘" className="size-6"/>
                    <img src={creator.avatarUrls["48x48"]} alt="지라프로필1" className="rounded-full size-10" />
                </div>
            </div>

        </div>
    );
}
