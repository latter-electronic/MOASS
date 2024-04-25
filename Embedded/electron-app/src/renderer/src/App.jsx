// App.jsx
import { BrowserRouter, Routes, Route } from "react-router-dom";

import Layout from "./components/Layout.jsx";

import Home from "./pages/home/HomePage.jsx";
import Board from "./pages/board";
import Jira from "./pages/jira";
import Alert from "./pages/alert";
import CallAlert from "./pages/common/CallAlertPage.jsx";

import Nameplate from "./pages/nameplate/NameplatePage.jsx"

export default function App() {
    return (
        <BrowserRouter>
            <div className="flex min-h-screen font-noto-sans">
                    <Routes>
                        <Route path="/" element={<Layout />}>
                            <Route index element={<Home />} />
                            <Route path="board" element={<Board />} />
                            <Route path="jira" element={<Jira />} />
                            <Route path="alert" element={<Alert />} />
                        </Route>
                        <Route path="/nameplate" element={<Nameplate />} />
                        <Route path="callalert" element={<CallAlert />} />
                    </Routes>
            </div>
        </BrowserRouter>
    );
}
