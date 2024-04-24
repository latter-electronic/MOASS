import React from 'react';

export default function HomeScheduleComponent() {
    const schedules = [
        {
            id: 1,
            type: '[Live]',
            title: 'introducing game',
            time: '09:00 - 10:00',
            color: 'blue',
            location: 'Youtube Live'
        },
        {
            id: 2,
            type: '[PJT]',
            title: 'Project',
            time: '10:00 - 12:00',
            color: 'blue',
            location: 'Processor'
        },
        {
            id: 3,
            type: '',
            title: 'Flip board reservation',
            time: '10:00 - 11:00',
            color: 'pink',
            location: 'Flipboard 1',
            participants: 3, // 참가자 수
            avatars: [ // 참가자 프로필 이미지
                'avatar1.jpg',
                'avatar2.jpg',
                'avatar3.jpg'
            ]
        }
    ];

    return (
        <div className="flex flex-col space-y-4">
            {schedules.map((schedule) => (
                <div key={schedule.id} className={`flex items-center p-4 rounded-lg shadow-md bg-white`}>
                    <div className={`border-l-4 ${schedule.color === 'blue' ? 'border-blue-500' : 'border-pink-500'} pl-4`}>
                        <p className="text-gray-800 font-semibold">{schedule.type} {schedule.title}</p>
                        <p className="text-gray-600">{schedule.location}</p>
                    </div>
                    <div className="ml-auto text-gray-800">{schedule.time}</div>
                    {schedule.participants && (
                        <div className="flex -space-x-2 ml-4">
                            {schedule.avatars.map((avatar, index) => (
                                <img key={index} src={avatar} alt="participant" className="w-6 h-6 rounded-full border-2 border-white" />
                            ))}
                            {schedule.participants > 3 && (
                                <span className="w-6 h-6 rounded-full bg-gray-200 flex items-center justify-center border-2 border-white">+{schedule.participants - 3}</span>
                            )}
                        </div>
                    )}
                </div>
            ))}
        </div>
    );
}
