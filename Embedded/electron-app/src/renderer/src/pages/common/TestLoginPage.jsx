import React, { useState } from 'react';
import { deviceLogin } from '../../services/deviceService.js';
import AuthStore from '../../stores/AuthStore.js';
import { useNavigate } from 'react-router-dom';

export default function TestLoginPage() {
    const navigate = useNavigate();

    const [deviceId, setDeviceId] = useState('');
    const [cardSerialId, setCardSerialId] = useState('');

    // Use AuthStore to manage login state
    const { login } = AuthStore(state => ({
        login: state.login
    }));

    const handleLogin = async () => {
        try {
            // Perform the login via deviceLogin service
            const response = await deviceLogin({ deviceId, cardSerialId });
            const { accessToken, refreshToken } = response.data.data;

            // If login is successful, store the access and refresh tokens
            login(accessToken, refreshToken);

            // Notify the user and navigate to home page or dashboard
            alert(`로그인 성공: \nAccessToken: ${accessToken}\nRefreshToken: ${refreshToken}`);
            navigate(`/`);
        } catch (error) {
            // Handle errors, such as wrong credentials or server issues
            alert(`로그인 실패: ${error.response?.data?.message}`);
        }
    };

    // Function to handle navigation to the main page
    const handleGoHome = () => {
        navigate('/');
    };

    return (
        <div className="flex items-center justify-center min-h-screen w-screen">
            <div className="p-8 bg-white shadow-md rounded">
                <h1 className="text-2xl font-bold text-center mb-6 text-black">로그인테스트</h1>
                <input
                    className="w-full p-2 mb-4 text-sm text-gray-700 bg-gray-100 rounded border border-gray-300"
                    type="text"
                    placeholder="기기 ID"
                    value={deviceId}
                    onChange={(e) => setDeviceId(e.target.value)}
                />
                <input
                    className="w-full p-2 mb-4 text-sm text-gray-700 bg-gray-100 rounded border border-gray-300"
                    type="text"
                    placeholder="카드 시리얼 ID"
                    value={cardSerialId}
                    onChange={(e) => setCardSerialId(e.target.value)}
                />
                <button 
                    className="w-full p-2 bg-blue-500 text-white rounded hover:bg-blue-700 mb-4"
                    onClick={handleLogin}>
                    로그인
                </button>
                <button 
                    className="w-full p-2 bg-gray-500 text-white rounded hover:bg-gray-700"
                    onClick={handleGoHome}>
                    메인 화면으로 이동
                </button>
            </div>
        </div>
    );
}
