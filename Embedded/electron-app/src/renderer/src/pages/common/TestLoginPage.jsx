import React, { useState } from 'react';
import { deviceLogin } from '../../services/deviceService.js';
import AuthStore from '../../stores/AuthStore.js';
import { useNavigate } from 'react-router-dom';


export default function TestLoginPage() {
    const navigate = useNavigate();

    const [deviceId, setDeviceId] = useState('');
    const [cardSerialId, setCardSerialId] = useState('');
    const { login, accessToken, refreshToken } = AuthStore(state => ({
        login: state.login,
        accessToken: state.accessToken,
        refreshToken: state.refreshToken
    }));


    const handleLogin = async () => {
        try {
            const response = await deviceLogin({ deviceId, cardSerialId });
            const { accessToken, refreshToken } = response.data.data;
            login(accessToken, refreshToken);
            alert(`로그인 성공: \nAccessToken: ${accessToken}\nRefreshToken: ${refreshToken}`);
            navigate(`/`);
        } catch (error) {
            alert(`로그인 실패: ${error.response?.data?.message}`);
        }
    };

    return (
        <div className="flex items-center justify-center min-h-screen  w-screen">
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
                    className="w-full p-2 bg-blue-500 text-white rounded hover:bg-blue-700"
                    onClick={handleLogin}>
                    로그인
                </button>
            </div>
        </div>
    );
}