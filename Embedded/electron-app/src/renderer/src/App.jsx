// App.jsx
import { HashRouter, Routes, Route, Navigate } from "react-router-dom";


import Layout from "./components/Layout.jsx";

import Home from "./pages/home/HomePage.jsx";
import Board from "./pages/board/BoardPage.jsx";
import BoardTest from "./pages/board/BoardTest.jsx";
import BoardHistory from './pages/board/BoardHistoryPage.jsx';
import Jira from "./pages/jira/JiraPage.jsx";
import Alert from "./pages/noti/NotiPage.jsx";
import CallAlert from "./pages/common/CallAlertPage.jsx";

import Nameplate from "./pages/nameplate/NameplatePage.jsx"
import TagNFC from "./pages/common/TagNFCPage.jsx";
import TagSuccess from "./pages/common/TagSuccessPage.jsx";
import TestLoginPage from "./pages/common/TestLoginPage.jsx";
import SSETestPage from "./pages/common/SSETestPage.jsx";

export default function App() {
    return (
        <HashRouter>
            <div className="flex min-h-screen font-noto-sans ml-1">
                <Routes>
                    <Route path="/" element={<Navigate replace to="/login" />} />
                    <Route path="/login" element={<TagNFC />} />
                    <Route path="/home" element={<Layout />}>
                        <Route index element={<Home />} />
                        <Route path="board" element={<Board />} />
                        <Route path="board/test" element={<BoardTest />} />
                        <Route path="board/history" element={<BoardHistory />} />
                        <Route path="jira" element={<Jira />} />
                        <Route path="alert" element={<Alert />} />
                    </Route>
                    <Route path="/nameplate" element={<Nameplate />} />
                    <Route path="/callalert" element={<CallAlert />} />
                    <Route path="/tagnfc" element={<TagNFC />} />
                    <Route path="/tagsuccess" element={<TagSuccess />} />
                    <Route path="/ssetest" element={<SSETestPage />} />
                </Routes>
            </div>
        </HashRouter>
    );
}
