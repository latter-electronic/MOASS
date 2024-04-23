import { BrowserRouter, Routes, Route } from "react-router-dom";

import Home from "./pages/home/index.jsx";
import Board from "./pages/board";
import Jira from "./pages/jira";
import Alert from "./pages/alert";
import Navbar from "./components/Navbar";

export default function App() {
    return (
        <BrowserRouter>
            <div className="flex">
                <Navbar />
                <main className="flex-1">
                    <Routes>
                        <Route path="/" element={<Home />} />
                        <Route path="/board" element={<Board />} />
                        <Route path="/jira" element={<Jira />} />
                        <Route path="/alert" element={<Alert />} />
                        {/* If you have a 404 page, you can use this to catch all unmatched routes */}
                        {/* <Route path="*" element={<NotFound />} /> */}
                    </Routes>
                </main>
            </div>
        </BrowserRouter>
    );
}