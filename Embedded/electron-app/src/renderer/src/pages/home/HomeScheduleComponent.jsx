import React from 'react';

import profileImg1 from './test/profileImg1.png'
import profileImg2 from './test/profileImg2.png'
import profileImg3 from './test/profileImg3.png'

export default function HomeScheduleComponent() {
    const schedules = [
        {
            id: 1,
            type: '[Live]',
            title: '게임업계 동향 소개',
            time: '09:00 - 10:00',
            color: 'blue',
            location: '박찬국 Youtube Live'
        },
        {
            id: 2,
            type: '[자율 PJT]',
            title: '프로젝트 진행',
            time: '10:00 - 12:00',
            color: 'blue',
            location: '담당강사 / 부울경 202'
        },
        {
            id: 3,
            type: '',
            title: '플립보드 예약',
            time: '10:00 - 11:00',
            color: 'pink',
            location: '1번 플립보드',
            participants: 6, // 참가자 수
            avatars: [ // 참가자 프로필 이미지
                profileImg1,
                profileImg2,
                profileImg3
            ]
        }
    ];

    return (
        <div className="flex flex-col space-y-4">
            {schedules.map((schedule) => (
                <div key={schedule.id} className={`flex items-center p-4 rounded-lg shadow-md bg-white max-w-screen-sm`}>
                    <div className={`border-l-4 ${schedule.color === 'blue' ? 'border-blue-500' : 'border-pink-500'} pl-4`}>
                        <p className="text-gray-800 font-semibold">{schedule.type} {schedule.title}</p>
                        <div className="flex items-center justify-between">
                            <p className="text-gray-600">{schedule.location}</p>
                            {schedule.avatars && (
                        <div className="flex -space-x-2 ml-4">
                            {schedule.avatars.map((avatar, index) => (
                                <img key={index} src={avatar} alt={`participant ${index + 1}`} className="w-6 h-6 rounded-full border-2 border-white shadow-sm" />
                            ))}
                            {schedule.participants > schedule.avatars.length && (
                                <span className="w-7 h-7 rounded-full text-xs text-black bg-gray-200 flex items-center justify-center border-2 border-white shadow-sm">+{schedule.participants - schedule.avatars.length}</span>
                            )}
                        </div>
                    )}
                        </div>
                    </div>
                    <div className="ml-auto text-gray-600">{schedule.time}</div>
                    
                </div>
            ))}
        </div>
    );
}
