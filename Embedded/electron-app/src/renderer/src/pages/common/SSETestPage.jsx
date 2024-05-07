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
        console.log('1. useEffect 함')
        if (accessToken) {
            console.log('2. 어세스토큰 있음')
            const eventService = new EventService('https://k10e203.p.ssafy.io/api/stream/team', {
                'Authorization': `Bearer ${accessToken}`
            });

            eventService.startListening((newData) => {
                updateData(newData);
                console.log('New data received:', newData);
            });

            return () => eventService.stopListening();
        }
    }, [updateData, accessToken]);

    return (
        <div className="p-4 w-screen flex items-center justify-center">
            <div className="p-8 bg-white shadow-md rounded w-2/5">
                <h1 className="text-xl font-semibold text-gray-800 mb-4">SSE Data Received</h1>
                <div className="text-gray-800">
                    {data ? <pre>{JSON.stringify(data, null, 2)}</pre> : <p>No data received yet.</p>}
                </div>
            </div>
        </div>
    );
}