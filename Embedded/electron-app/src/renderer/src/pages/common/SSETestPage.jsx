import React, { useEffect } from 'react';
import useStore from '../../stores/useStore.js';
import EventService from '../../services/EventService.js';
import useAuthStore from '../../stores/AuthStore.js';

export default function SSETestPage() {
    const { data, updateData } = useStore((state) => ({
        data: state.data,
        updateData: state.updateData,
    }));
    const { accessToken } = useAuthStore((state) => ({
        accessToken: state.accessToken,
    }));

    useEffect(() => {
        if (accessToken) {
            const eventService = new EventService('https://k10e203.p.ssafy.io/api/stream/team', {
                Authorization: `Bearer ${accessToken}`,
            });

            eventService.startListening((newData) => {
                try {
                    const parsedData = JSON.parse(newData); // JSON으로 파싱
                    updateData(parsedData);
                } catch (error) {
                    console.error('Failed to parse data:', error);
                    updateData({ newData });
                }
            });

            return () => eventService.stopListening();
        }
    }, [updateData, accessToken]);

    const renderData = (data) => {
        if (typeof data === 'string') {
            return <pre>{data}</pre>;
        } else if (typeof data === 'object') {
            return <pre>{JSON.stringify(data, null, 2)}</pre>;
        } else {
            return <pre>Unknown data format</pre>;
        }
    };

    return (
        <div className="p-4 w-screen flex items-center justify-center">
            <div className="p-8 bg-white shadow-md rounded w-2/5">
                <h1 className="text-xl font-semibold text-gray-800 mb-4">SSE Data Received</h1>
                <div className="text-gray-800">
                    {data ? renderData(data) : <p>No data received yet.</p>}
                </div>
            </div>
        </div>
    );
}
