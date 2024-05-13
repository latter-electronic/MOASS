import { useState, useEffect } from 'react'
import IssueIcon from '../../assets/images/jira/jiraIssueIcon.svg'
import { getEpicColorClasses } from '../../utils/colorUtils.js';
import { getIssueDetails } from '../../services/jiraService';

export default function JiraIssueCard({ issue }) {
    const [epicName, setEpicName] = useState('');
    const [epicColor, setEpicColor] = useState('');

    const { customfield_10014, summary, priority, assignee, customfield_10031 } = issue.fields;

    useEffect(() => {
        if (customfield_10014) {
            getIssueDetails(customfield_10014)
                .then(data => {
                    setEpicName(data.data.fields.customfield_10011);
                    setEpicColor(data.data.fields.customfield_10017);
                })
                .catch(error => console.error('Failed to fetch epic details:', error));
        }
    }, [customfield_10014]);

    return (
        <div className="flex flex-col mt-2 bg-white rounded-lg shadow p-3 px-5 gap-1 text-base">

            <div className="font-medium text-lg text-gray-700">{summary}</div>
            
            <div className="flex justify-between items-center">
                <div className="flex items-center gap-2">
                    <img src={IssueIcon} alt="jira issue icon" className="w-6 h-6" />
                    <span className={`text-j${epicColor} bg-j${epicColor}B px-2 py-1 rounded font-semibold`}>{epicName}</span>
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
