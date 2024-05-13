import { useEffect, useState } from 'react';
import { DragDropContext, Droppable, Draggable } from 'react-beautiful-dnd';
import IssueCard from './JiraIssueCard.jsx';
import dropdownArrow from '../../assets/images/jira/dropdown-arrow.svg';
import profile1 from '../../assets/images/jira/jiraProfileImg1.png';
import profile2 from '../../assets/images/jira/jiraProfileImg2.png';
import profile3 from '../../assets/images/jira/jiraProfileImg3.png';
import profile4 from '../../assets/images/jira/jiraProfileImg4.png';
import profile5 from '../../assets/images/jira/jiraProfileImg5.png';
import profile6 from '../../assets/images/jira/jiraProfileImg6.png';
import { fetchCurrentSprintIssues } from '../../services/jiraService.js';
import testDoneIssues from './proxyTest/testJson10001.json';

const profileImages = [profile1, profile2, profile3, profile4, profile5, profile6];

export default function JiraPage() {
    const [issues, setIssues] = useState({
        todo: [],
        inProgress: [],
        done: []
    });
    const [loading, setLoading] = useState({ todo: true, inProgress: true, done: false });
    const [selectedProfile, setSelectedProfile] = useState(null);

    useEffect(() => {
        async function fetchIssues(statusId, column) {
            try {
                const data = await fetchCurrentSprintIssues(statusId);
                setIssues(prev => ({ ...prev, [column]: data.issues || [] }));
            } catch (error) {
                console.error('Error fetching issues:', error);
                setIssues(prev => ({ ...prev, [column]: [] }));
            } finally {
                setLoading(prev => ({ ...prev, [column]: false }));
            }
        }

        fetchIssues('10000', 'todo');
        fetchIssues('3', 'inProgress');
        fetchIssues('10001', 'done');
    }, []);

    const onDragEnd = result => {
        const { source, destination } = result;
        if (!destination) {
            return;
        }
        if (source.droppableId === destination.droppableId && source.index === destination.index) {
            return;
        }

        const sourceColumn = issues[source.droppableId];
        const destColumn = issues[destination.droppableId];
        const [removed] = sourceColumn.splice(source.index, 1);
        destColumn.splice(destination.index, 0, removed);

        setIssues(prev => ({
            ...prev,
            [source.droppableId]: sourceColumn,
            [destination.droppableId]: destColumn
        }));
    };

    const getStatusName = (key) => {
        const statusNames = {
            todo: '해야 할 일',
            inProgress: '진행 중',
            done: '완료'
        };
        return statusNames[key] || key;
    };

    const handleProfileClick = (index) => {
        setSelectedProfile(index);
    };

    return (
        <DragDropContext onDragEnd={onDragEnd}>
            <div className="mx-auto p-6 h-screen overflow-hidden">
                <div className="flex items-center text-white font-extrabold text-3xl mb-5">
                    <div>S10P31E203 보드</div>
                    {/* <img src={dropdownArrow} alt="화살표" className="ml-2" /> */}
                    <div className="flex -space-x-2 ml-6">
                        {profileImages.map((avatar, index) => (
                            <button
                                key={index}
                                onClick={() => handleProfileClick(index)}
                                className={`w-10 h-10 rounded-full border-3 shadow-sm overflow-hidden relative ${selectedProfile === index ? 'z-10 ring-1 ring-blue-500 ring-offset-2 shadow-lg' : 'border-gray-900'}`}
                            >
                                <img src={avatar} alt={`participant ${index + 1}`} className="w-full h-full rounded-full" />
                            </button>
                        ))}
                    </div>
                </div>

                <div className="grid grid-cols-3 gap-5 h-full w-[88vw] ml-4">
                    {Object.keys(issues).map((key, index) => (
                        <Droppable key={key} droppableId={key}>
                            {(provided, snapshot) => (
                                <div
                                    ref={provided.innerRef}
                                    {...provided.droppableProps}
                                    className="flex flex-col bg-white/10 p-3 rounded-lg flex-1"
                                >
                                    <h3 className="text-white/70 text-lg ml-1 font-light mb-4">{getStatusName(key)}</h3>
                                    <div className="h-[76vh] overflow-auto scrollbar-hide">
                                        {loading[key] ? <div className="flex justify-center items-center h-full"><div className="text-lg text-white/30 font-normal">로딩 중...</div></div> : issues[key].length ? issues[key].map((issue, i) => (
                                            <Draggable key={issue.id} draggableId={issue.id} index={i}>
                                                {(provided) => (
                                                    <div
                                                        ref={provided.innerRef}
                                                        {...provided.draggableProps}
                                                        {...provided.dragHandleProps}
                                                    >
                                                        <IssueCard issue={issue} />
                                                    </div>
                                                )}
                                            </Draggable>
                                        )) : <div className="flex justify-center items-center h-full">
                                            <div className="text-2xl text-white/10 font-normal mb-6">해당 상태의 이슈가 없어요</div>
                                        </div>}
                                        {provided.placeholder}
                                    </div>
                                </div>
                            )}
                        </Droppable>
                    ))}
                </div>
            </div>
        </DragDropContext>
    );
}
