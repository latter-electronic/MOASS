import { HashRouter, Routes, Route, Navigate } from "react-router-dom";
import { useEffect } from 'react';
import Layout from "./components/Layout.jsx";

import Home from "./pages/home/HomePage.jsx";
import Board from "./pages/board/BoardPage.jsx";
import BoardTest from "./pages/board/BoardTest.jsx";
import BoardHistory from './pages/board/BoardHistoryPage.jsx';
import Jira from "./pages/jira/JiraPage.jsx";
import Alert from "./pages/noti/NotiPage.jsx";
import CallAlert from "./pages/common/CallAlertPage.jsx";
import Nameplate from "./pages/nameplate/NameplatePage.jsx";
import TagNFC from "./pages/common/TagNFCPage.jsx";
import TagSuccess from "./pages/common/TagSuccessPage.jsx";
import TestLoginPage from "./pages/common/TestLoginPage.jsx";
import SSETestPage from "./pages/common/SSETestPage.jsx";
import EventService from './services/EventService';
import { deviceLogout } from './services/deviceService';
import useAuthStore from './stores/AuthStore';

export default function App() {
    const { accessToken, deviceId } = useAuthStore((state) => ({
        accessToken: state.accessToken,
        deviceId: state.deviceId,
    }));

    useEffect(() => {
        if (accessToken) {
            const eventService = new EventService('https://k10e203.p.ssafy.io/api/stream/user', {
                Authorization: `Bearer ${accessToken}`,
            });

            eventService.startListening(async (newData) => {
                try {
                    const parsedData = JSON.parse(newData);

                    if (parsedData.command === 'order' && parsedData.type === 'logoutDevice') {
                        const studentId = parsedData.data.detail;
                        await handleLogoutDevice(studentId);
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
        } catch (error) {
            console.error('Failed to logout device:', error);
        }
    };

    return (
        <HashRouter>
            <div className="flex min-h-screen font-noto-sans">
                <Routes>
                    <Route path="/" element={<Layout />}>
                        <Route index element={<Home />} />
                        <Route path="board" element={<Board />} />
                        <Route path="board/test" element={<BoardTest />} />
                        <Route path="board/history" element={<BoardHistory />} />
                        <Route path="jira" element={<Jira />} />
                        <Route path="alert" element={<Alert />} />
                    </Route>
                    <Route path="/nameplate" element={<Nameplate />} />
                    <Route path="/callalert" element={<CallAlert />} />
                    <Route path="/login" element={<TagNFC />} />
                    <Route path="/testlogin" element={<TestLoginPage />} />
                    <Route path="/tagsuccess" element={<TagSuccess />} />
                    <Route path="/ssetest" element={<SSETestPage />} />
                </Routes>
            </div>
        </HashRouter>
    );
}
