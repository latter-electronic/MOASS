import React from 'react';

import profileImg1 from './test/profileImg1.png'
import profileImg2 from './test/profileImg2.png'
import profileImg3 from './test/profileImg3.png'

export default function HomeScheduleComponent() {
    const schedules = 
        [
            {
                id: 1,
                type: '[Live]',
                title: '게임업계 동향 소개',
                time: '09:00 - 10:00',
                color: 'border-blue-500',
                location: '박찬국 Youtube Live'
            },
            {
                id: 2,
                type: '[자율 PJT]',
                title: '프로젝트 진행',
                time: '10:00 - 12:00',
                color: 'border-blue-500',
                location: '담당강사 / 부울경 202'
            },
            {
                id: 3,
                type: '',
                title: '플립보드 예약',
                time: '10:00 - 11:00',
                color: 'border-pink-500',
                location: '1번 플립보드',
                participants: 6, // 참가자 수
                avatars: [ // 참가자 프로필 이미지
                    profileImg1,
                    profileImg2,
                    profileImg3
                ]
            },
            {
                id: 4,
                type: '[자율 PJT]',
                title: '프로젝트 진행',
                time: '11:00 - 12:00',
                color: 'border-blue-500',
                location: '담당강사 / 부울경 202'
            },
            {
                id: 5,
                type: '',
                title: '자치회+지역대표 회의',
                time: '12:00 - 13:00',
                color: 'border-stone-400',
                location: '로비 / 메모장 챙기기'
            },
            {
                id: 6,
                type: '',
                title: '점심 시간',
                time: '13:00 - 14:00',
                color: 'border-blue-500',
                location: ''
            },
            {
                id: 7,
                type: '[자율 PJT]',
                title: '프로젝트 진행',
                time: '14:00 - 17:00',
                color: 'border-blue-500',
                location: '담당강사 / 부울경 202'
            },
            {
                id: 8,
                type: '',
                title: '종료 미팅',
                time: '17:00 - 18:00',
                color: 'border-blue-500',
                location: '담당강사 / 부울경 202'
            }
        ];

    return (
        <div className="flex flex-col space-y-4 overflow-y-auto h-[calc(100vh-100px)] scrollbar-hide">
            {schedules.map((schedule) => (
                <div key={schedule.id} className={`flex items-center p-4 rounded-lg shadow-md bg-white max-w-screen-sm ml-12`}>
                    <div className={`border-l-4 ${schedule.color} pl-4`}>
                        <p className="text-gray-800 font-semibold text-xl mb-1">{schedule.type} {schedule.title}</p>
                        <div className="flex items-center justify-between">
                            <p className="text-gray-600 text-lg">{schedule.location}</p>
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
                    <div className="ml-auto text-gray-600 text-lg">{schedule.time}</div>
                </div>
            ))}
        </div>
    );
}
