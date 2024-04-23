import { NavLink } from 'react-router-dom';

export default function Navbar() {
    return (
        <nav className="flex flex-col justify-between h-screen bg-gray-800 text-white p-4">
            <div className="flex flex-col gap-4">
                <NavLink to="/" className="mb-4">
                    <div className="p-2 hover:bg-gray-700 rounded">Main</div>
                </NavLink>
                <NavLink to="/board" className="mb-4">
                    <div className="p-2 hover:bg-gray-700 rounded">Board</div>
                </NavLink>
                <NavLink to="/jira" className="mb-4">
                    <div className="p-2 hover:bg-gray-700 rounded">Jira</div>
                </NavLink>
            </div>
            <div>
                <NavLink to="/alert" className="mb-4">
                    <div className="p-2 hover:bg-gray-700 rounded">Alert</div>
                </NavLink>
            </div>
        </nav>
    );
}