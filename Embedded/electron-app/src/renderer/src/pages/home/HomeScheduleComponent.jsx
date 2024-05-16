import React, { useEffect, useState } from 'react';
import { fetchCurriculum } from '../../services/todoService.js';

import profileImg1 from './test/profileImg1.png'
import profileImg2 from './test/profileImg2.png'
import profileImg3 from './test/profileImg3.png'

export default function HomeScheduleComponent() {
    const [schedules, setSchedules] = useState([]);

    useEffect(() => {
        const fetchSchedules = async () => {
            try {
                const response = await fetchCurriculum('2024-05-13');
                if (response.data && response.data.courses) {
                    const formattedSchedules = response.data.courses.map((course, index) => ({
                        id: index + 1,
                        type: `[${course.majorCategory}]`,
                        title: course.title,
                        time: course.period,
                        color: 'border-blue-500',
                        location: `${course.teacher} / ${course.room}`
                    }));
                    setSchedules(formattedSchedules);
                }
            } catch (error) {
                console.error('Error fetching curriculum:', error);
            }
        };

        fetchSchedules();
    }, []);

    return (
        <div className="flex flex-col space-y-4 overflow-y-auto h-[calc(100vh-100px)] scrollbar-hide items-center">
            {schedules.map((schedule) => (
                <div key={schedule.id} className={`flex items-center p-4 rounded-lg shadow-md w-full bg-white max-w-screen-sm ml-8`}>
                    <div className={`border-l-4 ${schedule.color} pl-4`}>
                        <p className="text-gray-800 font-bold text-test mb-1">{schedule.type} {schedule.title}</p>
                        <div className="flex items-center justify-between">
                            <p className="text-gray-600 text-xl">{schedule.location}</p>
                            {schedule.avatars && (
                                <div className="flex -space-x-2 ml-4">
                                    {schedule.avatars.map((avatar, index) => (
                                        <img key={index} src={avatar} alt={`participant ${index + 1}`} className="size-8 rounded-full border-2 border-white shadow-sm" />
                                    ))}
                                    {schedule.participants > schedule.avatars.length && (
                                        <span className="size-8 rounded-full text-sm text-black bg-gray-200 flex items-center justify-center border-2 border-white shadow-sm">+{schedule.participants - schedule.avatars.length}</span>
                                    )}
                                </div>
                            )}
                        </div>
                    </div>
                    <div className="ml-auto text-gray-600 text-xl mr-2">{schedule.time}</div>
                </div>
            ))}
        </div>
    );
}
