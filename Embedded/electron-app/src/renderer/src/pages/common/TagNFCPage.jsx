import React, { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom' 
import useAuthStore from '../../stores/AuthStore.js'
import tagging_space from '../../assets/tag_nfc.png'
import axios from "axios";

export default function TagNFC() {
  const MOASS_API_URL = import.meta.env.VITE_MOASS_API_URL;
  const navigate = useNavigate()

  // const callTagSuccessFunction = () => {
  //   navigate(`/tagsuccess`)
  // }
  const { login, isAuthenticated } = useAuthStore((state) => ({
    login: state.login,
    isAuthenticated: state.isAuthenticated
  }))

  const [deviceId, setDeviceId] = useState('');
  const [cardSerialId, setCardSerialId] = useState('');

  // API 요청 함수
  const sendLoginRequest = async () => {
    const url = `https://${MOASS_API_URL}/api/device/login`;
    const payload = {
      'deviceId': deviceId,
      'cardSerialId': cardSerialId,
    };
  
    try {
      const response = await axios.post(url, payload, {
        headers: {
          'Content-Type': 'application/json'
        }
      });
  
      const data = response.data; // axios는 자동으로 JSON 파싱을 처리합니다
      if (response.status === 200) { // axios는 response.ok 대신 직접 status 코드를 확인합니다
        await login(data.accessToken, data.refreshToken);
        console.log('로그인 완료')
        navigate('/tagsuccess');
      } else {
        throw new Error(`API call failed with status ${response.status}: ${data.message}`);
      }
    } catch (error) {
      // axios는 네트워크 에러뿐만 아니라 2xx 범위를 벗어나는 상태 코드도 예외를 발생시킵니다
      console.error('API call error:', error.message);
    }
  };
  
  const handleSubmit = (event) => {
    event.preventDefault();
    sendLoginRequest();
  };


  useEffect(() => {
    const handleNfcData = (data) => {
      console.log('Received NFC data:', data)
      console.log('Type of data:', typeof data)                 
      try {
        const parsedData = JSON.parse(data)
        if (parsedData.accessToken && parsedData.refreshToken) {
          login(parsedData.accessToken, parsedData.refreshToken)
          console.log('navigate 시작')
          navigate('/tagsuccess')
          console.log('navigate 실행 완료')
        }
      } catch (error) {
        console.error('Error parsing NFC data:', error)
      }
    }

    window.userAPI?.onNfcData(handleNfcData)

    // 컴포넌트 언마운트 시에 이벤트 리스너 정리.
    return () => {
      window.userAPI?.removeNfcDataListener()
    }
  }, [login, navigate])

  return (
    <div className="flex flex-row justify-between h-dvh w-full p-12 text-center text-white">
      <div className="absolute top-0 left-0 m-4">
        <button
          onClick={() => navigate(-1)}
          className="text-xl bg-gray-300 hover:bg-gray-400 text-black font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
        >
          뒤로가기
        </button>
      </div>
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
              onChange={e => setDeviceId(e.target.value)}
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
              onChange={e => setCardSerialId(e.target.value)}
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
          alt="tagging space"
        />
        <div className="flex">
          <p>여기에 학생증을 태깅해주세요!</p>
        </div>
      </div>
    </div>
  )
}
