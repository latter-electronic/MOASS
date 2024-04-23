import { NavLink } from 'react-router-dom';

import mainIcon from '../assets/navbar_icon_main.svg';
import boardIcon from '../assets/navbar_icon_board.svg';
import jiraIcon from '../assets/navbar_icon_jira.svg';
import alertIcon from '../assets/navbar_icon_alert.svg';

export default function Navbar() {
    return (
        <nav className="flex flex-col justify-between w-20 h-screen bg-gray-800 text-white p-4">
            <div className="flex flex-col items-center gap-4">
                <NavLink to="/" className="mb-4">
                    <img src={mainIcon} alt="Main" className="p-2 hover:bg-gray-700 rounded" />
                </NavLink>
                <NavLink to="/board" className="mb-4">
                    <img src={boardIcon} alt="Board" className="p-2 hover:bg-gray-700 rounded" />
                </NavLink>
                <NavLink to="/jira" className="mb-4">
                    <img src={jiraIcon} alt="Jira" className="p-2 hover:bg-gray-700 rounded" />
                </NavLink>
            </div>
            <div className="flex items-center">
                <NavLink to="/alert" className="mb-4">
                    <img src={alertIcon} alt="Alert" className="p-2 hover:bg-gray-700 rounded" />
                </NavLink>
            </div>
        </nav>
    );
}
