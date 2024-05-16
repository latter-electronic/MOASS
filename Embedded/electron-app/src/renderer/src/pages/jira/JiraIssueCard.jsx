import IssueIcon from '../../assets/images/jira/jiraIssueIcon.svg';
import { epicColors } from '../../utils/colorUtils.js';

export default function JiraIssueCard({ issue }) {
    const { summary, priority, assignee, customfield_10031 } = issue.fields;
    const epic = issue.epic || {};

    const epicColor = epic.color;
    const backgroundColor = epicColors[`${epicColor}B`];
    const textColor = epicColors[epicColor];

    return (
        <div className="flex flex-col mt-2 bg-white rounded-lg shadow p-3 px-5 gap-1 text-base">
            <div className="font-medium text-lg text-gray-700">{summary}</div>
            
            <div className="flex justify-between items-center">
                <div className="flex items-center gap-2">
                    <img src={IssueIcon} alt="jira issue icon" className="w-6 h-6" />
                    <span 
                        style={{ backgroundColor: backgroundColor, color: textColor }} 
                        className="px-2 py-1 rounded font-semibold"
                    >
                        {epic.name}
                    </span>
                </div>
                <div className="flex items-center gap-2 mt-1">
                    <span className="bg-gray-200 rounded-full text-sm font-semibold px-2 py-1 text-gray-700">{customfield_10031}</span>
                    <img src={priority.iconUrl} alt="중요도 아이콘" className="size-6"/>
                    <img src={assignee.avatarUrls["48x48"]} alt="지라프로필" className="rounded-full size-10" />
                </div>
            </div>
        </div>
    );
}