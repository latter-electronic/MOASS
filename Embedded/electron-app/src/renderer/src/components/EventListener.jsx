import { useEffect, useCallback } from 'react';
import { useNavigate } from 'react-router-dom';
import EventService from '../services/EventService';
import { deviceLogout } from '../services/deviceService';
import useAuthStore from '../stores/AuthStore';
import useTodoStore from '../stores/todoStore';
import useNotiStore from '../stores/notiStore';
import { fetchTodos } from '../services/todoService'; // fetchTodos 임포트 추가
// import { updateUserStatus } from '../services/userService'

export default function EventListener({ children }) {
    const navigate = useNavigate();
    const { accessToken, deviceId, cardSerialId, logout } = useAuthStore((state) => ({
        accessToken: state.accessToken,
        deviceId: state.deviceId,
        cardSerialId: state.cardSerialId,  // userId
        logout: state.logout,
    }));

    const addNotification = useNotiStore(state => state.addNotification);

    // const handleUserStatusData = useCallback((event, data) => {
    //     const status = data.status === 'AWAY' ? '0' : data.status === 'STAY' ? '1' : null;
    //     console.log("status: ", status)
    //     updateUserStatus({ statusId: status }).then(() => {
    //         console.log(`User status updated to ${data.status}`);
    //     }).catch(error => {
    //         console.error('Error updating user status:', error);
    //     });
    // }, []);

    // useEffect(() => {
    //     window.electron.ipcRenderer.on('motion-detected', handleUserStatusData);

    //     return () => {
    //         window.electron.ipcRenderer.removeListener('motion-detected', handleUserStatusData);
    //     };
    // }, [handleUserStatusData]);


    useEffect(() => {
        if (accessToken) {
            const eventService = new EventService('https://k10e203.p.ssafy.io/api/stream/user', {
                Authorization: `Bearer ${accessToken}`,
            });

            eventService.startListening(async (newData) => {
                console.log("SSE Data Received:", newData.data);
                try {
                    const parsedData = JSON.parse(newData.data);

                    if (parsedData.command === 'order') {
                        if (parsedData.type === 'logoutDevice') {
                            const studentId = parsedData.data.detail;
                            await handleLogoutDevice(studentId);
                        } else if (parsedData.type === 'call') {
                            handleCallEvent(parsedData.data);
                        }
                    } else if (parsedData.command === 'notification') {
                        // 알림 데이터 처리
                        addNotification(parsedData.data);
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

        // 페이지로 이동
        navigate('/callalert', { state: { message, senderName, senderProfile } });
    };

    return <>{children}</>;
}
