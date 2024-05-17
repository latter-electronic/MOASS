import { useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import EventService from '../services/EventService';
import { deviceLogout } from '../services/deviceService';
import useAuthStore from '../stores/AuthStore';
import useTodoStore from '../stores/todoStore';
import { fetchTodos } from '../services/todoService'; // fetchTodos 임포트 추가

export default function EventListener({ children }) {
    const navigate = useNavigate();
    const { accessToken, deviceId, cardSerialId, logout } = useAuthStore((state) => ({
        accessToken: state.accessToken,
        deviceId: state.deviceId,
        cardSerialId: state.cardSerialId,  // userId
        logout: state.logout,
    }));

    const setTodos = useTodoStore(state => state.setTodos);

    useEffect(() => {
        if (accessToken) {
            const eventService = new EventService('https://k10e203.p.ssafy.io/api/stream/user', {
                Authorization: `Bearer ${accessToken}`,
            });

            eventService.startListening(async (newData) => {
                console.log("SSE Data Received:", newData.data); // 로그 추가
                try {
                    const parsedData = JSON.parse(newData.data);

                    if (parsedData.command === 'order') {
                        if (parsedData.type === 'logoutDevice') {
                            const studentId = parsedData.data.detail;
                            await handleLogoutDevice(studentId);
                        } else if (parsedData.type === 'call') {
                            handleCallEvent(parsedData.data);
                        }
                    } else if (parsedData.command === 'update' && parsedData.target === 'todoUpdate') {
                        // SSE에서 Todo 업데이트 명령을 수신하면 Todo 리스트를 다시 로드합니다.
                        await reloadTodos();
                    }
                } catch (error) {
                    console.error('Failed to parse data:', error);
                }
            });

            return () => eventService.stopListening();
        }
    }, [accessToken]);

    const reloadTodos = async () => {
        try {
            const response = await fetchTodos();
            console.log("Reloading Todos:", response.data.data); // 로그 추가
            setTodos(response.data.data.map(todo => ({
                todoId: todo.todoId,
                content: todo.content,
                completedFlag: todo.completedFlag,
                createdAt: todo.createdAt,
                updatedAt: todo.updatedAt,
                completedAt: todo.completedAt,
            })));
        } catch (err) {
            console.error("Failed to reload todos:", err);
        }
    };

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
