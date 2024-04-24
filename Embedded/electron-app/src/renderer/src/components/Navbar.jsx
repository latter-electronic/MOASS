import React, { useState, useEffect } from 'react';
import { NavLink } from 'react-router-dom';
import { fetchAllUsers } from '../services/userService.js';
import useUIStore from '../stores/UIStore.js';

import mainIcon from '../assets/navbar_icon_main.svg';
import mainIcon_w from '../assets/navbar_icon_main_white.svg';
import boardIcon from '../assets/navbar_icon_board.svg';
import boardIcon_w from '../assets/navbar_icon_board_white.svg';
import jiraIcon from '../assets/navbar_icon_jira.svg';
import jiraIcon_w from '../assets/navbar_icon_jira_white.svg';
import alertIcon from '../assets/navbar_icon_alert.svg';
import alertIcon_w from '../assets/navbar_icon_alert_white.svg';
import testProfileImg from '../assets/profileImageTest.jpg';

export default function Navbar() {
    const { activeTab, setActiveTab } = useUIStore();  // 네브바 선택 아이콘
    const [users, setUsers] = useState([]); // 사용자 데이터 저장할곳

    useEffect(() => {
        const loadUsers = async () => {
            try {
                const userData = await fetchAllUsers();
                setUsers(userData); // API 호출 결과를 상태에 저장
            } catch (error) {
                console.error('사용자 데이터를 불러오는 중 오류가 발생했습니다:', error);
            }
        };

        loadUsers(); // 컴포넌트 마운트 시 사용자 데이터 불러오기
    }, []); // 빈 의존성 배열을 제공하여 컴포넌트가 마운트될 때 한 번만 호출되도록 설정

    return (
        <nav className="flex flex-col justify-between w-24 h-screen bg-gray-800 text-white p-4">
            <div className="flex flex-col items-center">
                <div className="mt-2 relative flex justify-center items-center w-16 h-16 rounded-full bg-emerald-500">
                    <img src={ testProfileImg } alt="프사" className="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-14 h-14 rounded-full" />
                </div>
            </div>
            <div className="flex flex-col items-center gap-2">
                <NavLink to="/" onClick={() => setActiveTab('/')} className={activeTab === '/' ? '' : 'opacity-50'}>
                    <img src={activeTab === '/' ? mainIcon : mainIcon_w} alt="Main" className="p-2 hover:bg-gray-700 rounded size-24" />
                </NavLink>
                <NavLink to="/board" onClick={() => setActiveTab('/board')} className={activeTab === '/board' ? '' : 'opacity-50'}>
                    <img src={activeTab === '/board' ? boardIcon : boardIcon_w} alt="Board" className="p-2 hover:bg-gray-700 rounded size-24" />
                </NavLink>
                <NavLink to="/jira" onClick={() => setActiveTab('/jira')} className={activeTab === '/jira' ? '' : 'opacity-50'}>
                    <img src={activeTab === '/jira' ? jiraIcon : jiraIcon_w} alt="Jira" className="p-2 hover:bg-gray-700 rounded size-24" />
                </NavLink>
                <NavLink to="/alert" onClick={() => setActiveTab('/alert')} className={activeTab === '/alert' ? '' : 'opacity-50'}>
                    <img src={activeTab === '/alert' ? alertIcon : alertIcon_w} alt="Alert" className="p-2 hover:bg-gray-700 rounded size-24" />
                </NavLink>
            </div>
        </nav>
    );
}
