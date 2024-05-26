import { HashRouter, Routes, Route } from "react-router-dom";
import Layout from "./components/Layout.jsx";
import { useEffect, useState } from 'react';

import Home from "./pages/home/HomePage.jsx";
import Board from "./pages/board/BoardPage.jsx";
import BoardDetail from "./pages/board/BoardDetailPage.jsx";
import BoardHistory from './pages/board/BoardHistoryPage.jsx';
import Jira from "./pages/jira/JiraPage.jsx";
import Alert from "./pages/noti/NotiPage.jsx";
import CallAlert from "./pages/common/CallAlertPage.jsx";
import LogoutNameplate from "./pages/nameplate/LogoutNameplatePgae.jsx";
import Nameplate from "./pages/nameplate/NameplatePage.jsx";
import TagNFC from "./pages/common/TagNFCPage.jsx";
import TagSuccess from "./pages/common/TagSuccessPage.jsx";
import TestLoginPage from "./pages/common/TestLoginPage.jsx";
import SSETestPage from "./pages/common/SSETestPage.jsx";
import EventListener from "./components/EventListener.jsx";

import useGlobalStore from './stores/useGlobalStore.js';
import { updateUserStatus } from './services/userService.js';

export default function App() {
    const { user, setUser } = useGlobalStore((state) => ({
        user: state.user,
        setUser: state.setUser,
    }));

    useEffect(() => {
        const handleMotionDetected = (event, data) => {
            if (data.status === 'AWAY' || data.status === 'STAY') {
                const newStatus = data.status === 'AWAY' ? '0' : '1';
                console.log("New status: ", newStatus);

                if (newStatus !== user.statusId.toString()) {
                    updateUserStatus({ statusId: newStatus })
                        .then(() => {
                            console.log(`User status updated to ${data.status}`);
                            setUser({ ...user, statusId: parseInt(newStatus) });
                        })
                        .catch(error => {
                            console.error('Error updating user status:', error);
                        });
                }
            }
        };

        if (window.electron && window.electron.ipcRenderer) {
            window.electron.ipcRenderer.on('motion-detected', handleMotionDetected);
        } else {
            console.error("ipcRenderer is not available");
        }

        return () => {
            if (window.electron && window.electron.ipcRenderer) {
                window.electron.ipcRenderer.removeListener('motion-detected', handleMotionDetected);
            }
        };
    }, [user, setUser]);

    return (
        <HashRouter>
            <EventListener>
                <div className="flex min-h-screen font-noto-sans">
                    <Routes>
                        <Route path="/" element={<Layout />}>
                            <Route index element={<Home />} />
                            <Route path="board" element={<Board />} />
                            <Route path="board/history" element={<BoardHistory />} />
                            <Route path="jira" element={<Jira />} />
                            <Route path="alert" element={<Alert />} />
                        </Route>
                        <Route path="/board/detail" element={<BoardDetail />} />
                        <Route path="/logoutnameplate" element={<LogoutNameplate/>}/>
                        <Route path="/nameplate" element={<Nameplate />} />
                        <Route path="/callalert" element={<CallAlert />} />
                        <Route path="/login" element={<TagNFC />} />
                        <Route path="/testlogin" element={<TestLoginPage />} />
                        <Route path="/tagsuccess" element={<TagSuccess />} />
                        <Route path="/ssetest" element={<SSETestPage />} />
                    </Routes>
                </div>
            </EventListener>
        </HashRouter>
    );
}
