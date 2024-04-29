import React from 'react';
import useAuthStore from '../../stores/AuthStore.js';

export default function LogoutButton() {
  const { accessToken, logout } = useAuthStore(state => ({
    accessToken: state.accessToken,
    logout: state.logout
  }));

  const handleLogout = async () => {
    if (!accessToken) {
      console.error('No access token available.');
      return;
    }

    try {
      const response = await fetch(`${process.env.VITE_MOASS_API_URL}/api/device/logout`, {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${accessToken}`,
          'Content-Type': 'application/json'
        }
      });

      if (response.ok) {
        logout();  // 상태 업데이트
        alert('로그아웃되었습니다.');
      } else {
        const responseData = await response.json();
        throw new Error(responseData.message || '로그아웃에 실패했습니다.');
      }
    } catch (error) {
      alert(error.message);
    }
  };

  return (
    <button 
      onClick={handleLogout}
      className="bg-sky-400 hover:bg-sky-700 text-white font-bold py-2 px-4 rounded-lg shadow-md transition duration-300 ease-in-out"
    >
      로그아웃
    </button>
  );
}
