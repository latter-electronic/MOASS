import React, { useEffect, useState } from 'react';
import { fetchCurriculum } from '../../services/todoService.js';
import { fetchReservationInfo } from '../../services/reservationService.js';

export default function HomeScheduleComponent() {
    const [schedules, setSchedules] = useState([]);
    const [error, setError] = useState(null);
    const [cache, setCache] = useState({}); // 캐시 상태 추가

    const getFormattedDate = (date) => {
        const options = { month: 'long', day: 'numeric', weekday: 'long' }; // 연도를 제외한 옵션
        return new Date(date).toLocaleDateString('ko-KR', options);
    };

    useEffect(() => {
        const fetchSchedules = async () => {
            try {
                // 하드코딩된 날짜 리스트
                const dates = ['2024-05-20', '2024-05-21', '2024-05-22'];

                let formattedCurriculumSchedules = [];
                let formattedReservationSchedules = [];

                // 각 날짜에 대한 커리큘럼 데이터를 가져옴
                for (const date of dates) {
                    if (cache[date]) {
                        // 캐시에 데이터가 있는 경우
                        formattedCurriculumSchedules = [...formattedCurriculumSchedules, ...cache[date]];
                    } else {
                        // 캐시에 데이터가 없는 경우 API 호출
                        const curriculumResponse = await fetchCurriculum(date);
                        if (curriculumResponse.data && curriculumResponse.data.courses) {
                            const formattedSchedules = curriculumResponse.data.courses.map((course, index) => ({
                                id: `curriculum-${date}-${index + 1}`,
                                date: date, // 날짜 추가
                                type: `[${course.majorCategory}]`,
                                title: course.title,
                                time: course.period,
                                color: 'border-blue-500',
                                location: `${course.teacher} / ${course.room}`
                            }));
                            formattedCurriculumSchedules = [...formattedCurriculumSchedules, ...formattedSchedules];
                            // 캐시에 저장
                            setCache(prevCache => ({ ...prevCache, [date]: formattedSchedules }));
                        }
                    }
                }

                // const reservationResponse = await fetchReservationInfo();
                // if (reservationResponse.data) {
                //     formattedReservationSchedules = reservationResponse.data.map((reservation, index) => ({
                //         id: `reservation-${index}`,
                //         date: reservation.infoDate, // 날짜 추가
                //         type: '',
                //         title: reservation.reservationName,
                //         time: `${reservation.infoDate} ${reservation.infoTime}`,
                //         color: 'border-pink-500',
                //         location: reservation.infoName,
                //         participants: reservation.userSearchInfoDtoList.length,
                //         avatars: reservation.userSearchInfoDtoList.map(user => user.profileImg)
                //     }));
                // }

                setSchedules([...formattedCurriculumSchedules, ...formattedReservationSchedules]);
            } catch (err) {
                console.error('Error fetching schedules:', err);
                setError('Failed to load schedules');
            }
        };

        fetchSchedules();
    }, [cache]);

    if (error) {
        return <div className="text-red-500">{error}</div>;
    }

    const groupedSchedules = schedules.reduce((groups, schedule) => {
        const date = schedule.date;
        if (!groups[date]) {
            groups[date] = [];
        }
        groups[date].push(schedule);
        return groups;
    }, {});

    return (
        <div className="flex flex-col space-y-4 overflow-y-auto h-[calc(100vh-70px)] scrollbar-hide items-center">
            {Object.keys(groupedSchedules).map((date) => (
                <div key={date} className="w-full max-w-screen-sm ml-8">
                    <div className="flex items-center">
                        <div className="text-white/50 p-2">
                            {getFormattedDate(date)}
                        </div>
                        <div className="flex-grow border-t border-white/50 mx-2"></div>
                    </div>
                    {groupedSchedules[date].map((schedule) => (
                        <div key={schedule.id} className={`flex items-center p-4 rounded-lg shadow-md w-full bg-white max-w-screen-sm mb-4`}>
                            <div className={`border-l-4 ${schedule.color} pl-4`}>
                                <p className="text-gray-800 font-bold text-test mb-1">{schedule.type} {schedule.title}</p>
                                <div className="flex items-center justify-between">
                                    <p className="text-gray-600 text-xl">{schedule.location}</p>
                                    {schedule.avatars && (
                                        <div className="flex -space-x-2 ml-4">
                                            {schedule.avatars.slice(0, 3).map((avatar, index) => (
                                                <img key={index} src={avatar} alt={`participant ${index + 1}`} className="size-8 rounded-full border-2 border-white shadow-sm" />
                                            ))}
                                            {schedule.participants > 3 && (
                                                <span className="size-8 rounded-full text-sm text-black bg-gray-200 flex items-center justify-center border-2 border-white shadow-sm">+{schedule.participants - 3}</span>
                                            )}
                                        </div>
                                    )}
                                </div>
                            </div>
                            <div className="ml-auto text-gray-600 text-xl mr-2">{schedule.time}</div>
                        </div>
                    ))}
                </div>
            ))}
        </div>
    );
}
