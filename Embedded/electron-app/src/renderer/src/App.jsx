// App.jsx
import { BrowserRouter, Routes, Route } from "react-router-dom";

import Home from "./pages/home/index.jsx";
import Board from "./pages/board";
import Jira from "./pages/jira";
import Alert from "./pages/alert";
import Navbar from "./components/Navbar";
import CallAlert from "./pages/common/CallAlertPage.jsx";

export default function App() {
    return (
        <BrowserRouter>
            <div className="flex min-h-screen font-noto-sans">
                <main className="flex-grow">
                    <Routes>
                        <Route path="/" element={<Home />} />
                        <Route path="/board" element={<Board />} />
                        <Route path="/jira" element={<Jira />} />
                        <Route path="/alert" element={<Alert />} />
                        <Route path="/callalert" element={<CallAlert />} />
                    </Routes>
                </main>
                {/* Correct the className and use fixed or absolute positioning with right-0 to stick it to the right */}
                <Navbar className="fixed inset-y-0 right-0"/>
            </div>
        </BrowserRouter>
    );
}
