import { useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import EventService from '../services/EventService';
import { deviceLogout } from '../services/deviceService';
import useAuthStore from '../stores/AuthStore';

export default function EventListener({ children }) {
    const navigate = useNavigate();
    const { accessToken, deviceId, cardSerialId, logout } = useAuthStore((state) => ({
        accessToken: state.accessToken,
        deviceId: state.deviceId,
        cardSerialId: state.cardSerialId,  // userId
        logout: state.logout,
    }));

    useEffect(() => {
        if (accessToken) {
            const eventService = new EventService('https://k10e203.p.ssafy.io/api/stream/user', {
                Authorization: `Bearer ${accessToken}`,
            });

            eventService.startListening(async (newData) => {
                console.log(newData.data)
                try {
                    const parsedData = JSON.parse(newData.data);

                    if (parsedData.command === 'order') {
                        if (parsedData.type === 'logoutDevice') {
                            const studentId = parsedData.data.detail;
                            await handleLogoutDevice(studentId);
                        } else if (parsedData.type === 'call') {
                            handleCallEvent(parsedData.data);
                        }
                    }
                } catch (error) {
                    console.error('Failed to parse data:', error);
                }
            });

            return () => eventService.stopListening();
        }
    }, [accessToken]);

    const handleLogoutDevice = async (studentId) => {
        try {
            const logoutData = { deviceId: deviceId || 'dddd2', userId: studentId };
            await deviceLogout(logoutData);
            console.log(`Device with student ID ${studentId} logged out successfully.`);

            logout();  // store 상태 변경
            alert('로그아웃 성공!');
            navigate('/login');
        } catch (error) {
            console.error('Failed to logout device:', error);
            alert('로그아웃 중 에러 발생');
        }
    };

    const handleCallEvent = (data) => {
        const { message, detail } = data;
        const [senderName, senderProfile] = detail.split(',');

        alert(`Call from: ${senderName}\nMessage: ${message}\nProfile: ${senderProfile}`);

        // 페이지로 이동
        navigate('/callalert', { state: { message, senderName, senderProfile } });
    };

    return <>{children}</>;
}
