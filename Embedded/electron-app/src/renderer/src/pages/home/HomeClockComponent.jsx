import React, { useState, useEffect } from 'react';

export default function HomeClockComponent() {
    // 상태로 현재 시간 관리
    const [currentTime, setCurrentTime] = useState(new Date());

    useEffect(() => {
        // 1초마다 현재 시간을 업데이트하는 인터벌 설정
        const timer = setInterval(() => {
            setCurrentTime(new Date());
        }, 1000);

        // 컴포넌트가 언마운트될 때 인터벌 정리
        return () => {
            clearInterval(timer);
        };
    }, []);

    // 현재 시간을 포맷에 맞게 표시
    const formattedTime = currentTime.toLocaleTimeString('ko-KR', {
        hour: '2-digit',
        minute: '2-digit'
    });

    // 현재 날짜를 포맷에 맞게 표시
    const formattedDate = currentTime.toLocaleDateString('ko-KR', {
        year: 'numeric',
        month: 'long',
        day: 'numeric',
        weekday: 'long',
    });

    return (
        <div className="text-white rounded-lg p-4 text-center">
            <div className="text-lg opacity-70">
                {formattedDate} ☀
            </div>
            <div className="text-5xl font-semibold">
                {formattedTime}
            </div>
        </div>
    );
}
