<<<<<<< 15b0b10d018b18e13639876ac175424004406466
// TagNFCPage.jsx
import React, { useState, useEffect, useCallback } from 'react'
import { useNavigate } from 'react-router-dom'
import AuthStore from '../../stores/AuthStore.js'
import { deviceLogin } from '../../services/deviceService.js'
import LeftArrow from '../../assets/left_arrow.png'
import MozzyLogin from '../../assets/mozzy_login.png'

export default function TagNFC() {
  const [deviceId, setDeviceId] = useState('')
  const [cardSerialId, setCardSerialId] = useState('')
  const [triggerLogin, setTriggerLogin] = useState(false)
  const [showForm, setShowForm] = useState(false)
  const [timeoutId, setTimeoutId] = useState(null)

  const { login } = AuthStore((state) => ({
    login: state.login,
  }))

  const navigate = useNavigate()

  const ipcLoginHandle = () => window.electron.ipcRenderer.send('login-success', 'login')

  const handleSuccessfulLogin = useCallback((accessToken, refreshToken, deviceId, cardSerialId) => {
    login(accessToken, refreshToken, deviceId, cardSerialId)
    localStorage.setItem('accessToken', accessToken)
    localStorage.setItem('refreshToken', refreshToken)
    localStorage.setItem('deviceId', deviceId)
    localStorage.setItem('cardSerialId', cardSerialId)
=======
import React, { useState, useEffect, useCallback } from 'react';
import { useNavigate } from 'react-router-dom';
import AuthStore from '../../stores/AuthStore.js';
import useGlobalStore from '../../stores/useGlobalStore.js';
import { deviceLogin } from '../../services/deviceService.js';
import tagging_space from '../../assets/tag_nfc.png';

export default function TagNFC() {
  const [deviceId, setDeviceId] = useState('');
  const [cardSerialId, setCardSerialId] = useState('');
  const { login } = AuthStore((state) => ({ login: state.login }));
  const { fetchUserInfo } = useGlobalStore((state) => ({ fetchUserInfo: state.fetchUserInfo }));
  const navigate = useNavigate();

  const ipcLoginHandle = () => window.electron.ipcRenderer.send('login-success', 'login');

  const handleSuccessfulLogin = useCallback(async (accessToken, refreshToken, deviceId, cardSerialId) => {
    login(accessToken, refreshToken, deviceId, cardSerialId);
    localStorage.setItem('accessToken', accessToken);
    localStorage.setItem('refreshToken', refreshToken);
    localStorage.setItem('deviceId', deviceId);
    localStorage.setItem('cardSerialId', cardSerialId);
>>>>>>> 17ed36cf94e0084781ed7a1a136dcee5c9bb83aa

    await fetchUserInfo();  // 사용자 정보 불러오기
    navigate('/tagsuccess');
    setTimeout(() => {
      navigate('/');
    }, 2000);
    ipcLoginHandle();
  }, [login, fetchUserInfo, navigate]);

  const handleLogin = useCallback(async () => {
    if (deviceId && cardSerialId) {
      try {
        const response = await deviceLogin({ deviceId, cardSerialId });
        const { accessToken, refreshToken } = response.data.data;
        handleSuccessfulLogin(accessToken, refreshToken, deviceId, cardSerialId);
      } catch (error) {
        alert(`로그인 실패: ${error.response?.data?.message}`);
      }
    }
  }, [deviceId, cardSerialId, handleSuccessfulLogin]);

  const handleNfcData = useCallback((event, data) => {
    setDeviceId(data.deviceId);
    setCardSerialId(data.cardSerialId);
  }, []);

  useEffect(() => {
    if (deviceId && cardSerialId) {
      handleLogin();
    }
  }, [deviceId, cardSerialId, handleLogin]);

  useEffect(() => {
    window.electron.ipcRenderer.on('nfc-data', handleNfcData);
    return () => {
      window.electron.ipcRenderer.removeListener('nfc-data', handleNfcData);
    };
  }, [handleNfcData]);

  const handleSubmit = (event) => {
<<<<<<< 15b0b10d018b18e13639876ac175424004406466
    event.preventDefault()
    setTriggerLogin(true)
    clearTimeout(timeoutId)
  }

  const handleImageClick = () => {
    setShowForm(true)
  }

  useEffect(() => {
    if (showForm) {
      const id = setTimeout(() => {
        setShowForm(false)
      }, 10000) // 10초 후에 폼을 숨기고 사진으로 돌아갑니다.
      setTimeoutId(id)

      return () => clearTimeout(id) // 컴포넌트 언마운트 시 타이머 해제
    }
  }, [showForm])

  const handleInputChange = (setter) => (event) => {
    setter(event.target.value)
    clearTimeout(timeoutId) // 입력 시 타이머 해제
    const id = setTimeout(() => {
      setShowForm(false)
    }, 10000); // 10초 타이머 재설정
    setTimeoutId(id)
  }

  return (
    <div className="flex flex-row justify-between h-dvh w-full p-12 text-center text-white">
      <div className="flex-1 flex flex-col">
        <div className='flex flex-row'>
          <img
          className="flex animate-bounce-left-right my-3 h-36 w-40"
          src={LeftArrow}
=======
    event.preventDefault();
    handleLogin();
  };

  return (
    <div className="flex flex-row justify-between h-dvh w-full p-12 text-center text-white">
      <div className="flex-1 flex items-center justify-center">
        <form onSubmit={handleSubmit} className="bg-white p-4 rounded-lg">
          <div className="mb-4">
            <label className="block text-gray-700 text-sm font-bold mb-2" htmlFor="deviceId">
              Device ID
            </label>
            <input
              type="text"
              id="deviceId"
              className="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
              value={deviceId}
              onChange={(e) => setDeviceId(e.target.value)}
              required
            />
          </div>
          <div className="mb-6">
            <label className="block text-gray-700 text-sm font-bold mb-2" htmlFor="cardSerialId">
              Card Serial ID
            </label>
            <input
              type="text"
              id="cardSerialId"
              className="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
              value={cardSerialId}
              onChange={(e) => setCardSerialId(e.target.value)}
              required
            />
          </div>
          <div className="flex items-center justify-between">
            <button
              type="submit"
              className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
            >
              Login
            </button>
          </div>
        </form>
      </div>
      <div className="flex-1 flex flex-col"></div>
      <div className="flex-1 flex flex-col items-center justify-center">
        <img
          className="flex justify-center items-center size-21"
          src={tagging_space}
>>>>>>> 17ed36cf94e0084781ed7a1a136dcee5c9bb83aa
          alt="tagging space"
          />
          <div className="flex mt-6 ml-10">
            <p className='mt-10 text-4xl'>여기에 학생증을 태깅해 주세요!</p>
          </div>
        </div>
        <div>
          {/* 모아스 로고나 슬로건 넣기 */}
        </div>
      </div>
      {/* <div className="flex-1 flex flex-col">
      </div> */}
      <div className="flex-1 flex items-center justify-center">
      {showForm ? (
          <form onSubmit={handleSubmit} className="bg-white p-8 rounded-lg shadow-lg w-80 max-w-md">
            <div className="mb-4">
              <label className="block text-gray-700 text-sm font-bold mb-2" htmlFor="deviceId">
                Device ID
              </label>
              <input
                type="text"
                id="deviceId"
                className="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
                value={deviceId}
                // onChange={(e) => setDeviceId(e.target.value)}
                onChange={handleInputChange(setDeviceId)}
                required
              />
            </div>
            <div className="mb-6">
              <label className="block text-gray-700 text-sm font-bold mb-2" htmlFor="cardSerialId">
                Card Serial ID
              </label>
              <input
                type="text"
                id="cardSerialId"
                className="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
                value={cardSerialId}
                // onChange={(e) => setCardSerialId(e.target.value)}
                onChange={handleInputChange(setCardSerialId)}
                required
              />
            </div>
            <div className="flex items-center justify-between">
              <button
                type="submit"
                className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
              >
                Login
              </button>
            </div>
          </form>
        ) : (
          <img
            src={MozzyLogin}
            alt="Mozzy Login"
            className="cursor-pointer mt-14"
            onClick={handleImageClick}
          />
        )}
      </div>
    </div>
  );
}
