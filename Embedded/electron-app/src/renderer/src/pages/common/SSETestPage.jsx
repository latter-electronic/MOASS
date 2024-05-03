import React, { useEffect } from 'react';
import useStore from '../../stores/useStore.js';
import EventService from '../../services/EventService.js';
import useAuthStore from '../../stores/AuthStore.js';

export default function SSETestPage() {
    const { data, updateData } = useStore(state => ({
        data: state.data,
        updateData: state.updateData
    }));
    const { accessToken } = useAuthStore(state => ({
        accessToken: state.accessToken
    }));

    useEffect(() => {
        console.log('useEffect 시작')
        if (accessToken) {
            console.log('accessToken: ' + accessToken)
            // EventService 인스턴스 생성하고 헤더에 토큰을 포함
            const eventService = new EventService('https://k10e203.p.ssafy.io/api/stream/user', {
                'Authorization': `Bearer ${accessToken}`
            });

            // EventService를 통해 SSE 데이터 수신 시작
            eventService.onmessage((newData) => {
                updateData(newData);
                console.log('수신중~')
            });

            // 컴포넌트 언마운트 시 EventService를 통해 연결 종료
            return () => {
                eventService.stopListening();
            };
        }
    }, [updateData, accessToken]); // 의존성 배열에 accessToken 추가

    // 데이터를 안전하게 렌더링하는 함수
    const renderData = (data) => {
        // 데이터 타입 확인 후 적절하게 렌더링
        if (typeof data === 'string' || typeof data === 'number') {
            return data; // 문자열 또는 숫자는 직접 렌더링
        } else {
            return <pre>{JSON.stringify(data, null, 2)}</pre>; // 객체 또는 배열은 JSON 형태로 렌더링
        }
    };

    return (
        <div className="p-4 w-screen flex items-center justify-center">
            <div className="p-8 bg-white shadow-md rounded w-2/5">
                <h1 className="text-xl font-semibold text-gray-800 mb-4">SSE Data Received</h1>
                <div>{renderData(data)}</div>  // 데이터 렌더링
            </div>
        </div>
    );
}