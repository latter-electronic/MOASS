// TagNFCPage.jsx
import React, { useState, useEffect, useCallback } from 'react'
import { useNavigate } from 'react-router-dom'
import AuthStore from '../../stores/AuthStore.js'
import { deviceLogin } from '../../services/deviceService.js'
import tagging_space from '../../assets/tag_nfc.png'

export default function TagNFC() {
  const [deviceId, setDeviceId] = useState('')
  const [cardSerialId, setCardSerialId] = useState('')
  const [triggerLogin, setTriggerLogin] = useState(false)
  const { login } = AuthStore((state) => ({
    login: state.login,
  }))

  const navigate = useNavigate()
  // 수정 필요함
  const ipcLoginHandle = () => window.electron.ipcRenderer.send('login-success', 'login')

  // 로그인 성공 후 로직
  const handleSuccessfulLogin = useCallback((accessToken, refreshToken, deviceId, cardSerialId) => {
    login(accessToken, refreshToken, deviceId, cardSerialId)
    localStorage.setItem('accessToken', accessToken)
    localStorage.setItem('refreshToken', refreshToken)
    localStorage.setItem('deviceId', deviceId)
    localStorage.setItem('cardSerialId', cardSerialId)

    navigate('/tagsuccess')
    setTimeout(() => {
      navigate('/')
      console.log('navigate 실행 완료')
    }, 2000)
    ipcLoginHandle()
  }, [login, navigate])

  // 일반 로그인 로직
  const handleLogin = useCallback(async () => {
    if (deviceId && cardSerialId) {
      try {
        const response = await deviceLogin({ deviceId, cardSerialId })
        const { accessToken, refreshToken } = response.data.data
        console.log(`로그인 성공: \nAccessToken: ${accessToken}\nRefreshToken: ${refreshToken}`)
        handleSuccessfulLogin(accessToken, refreshToken, deviceId, cardSerialId)
      } catch (error) {
        alert(`로그인 실패: ${error.response?.data?.message}`)
      }
    }
  }, [deviceId, cardSerialId, handleSuccessfulLogin])

  const handleNfcData = useCallback((event, data) => {
    setDeviceId(data.deviceId)
    setCardSerialId(data.cardSerialId)
    setTriggerLogin(true)
  }, [])

  useEffect(() => {
    if (triggerLogin) {
      handleLogin();
      setTriggerLogin(false);
    }
  }, [triggerLogin, handleLogin]);

  useEffect(() => {
    window.electron.ipcRenderer.on('nfc-data', handleNfcData);
    return () => {
      window.electron.ipcRenderer.removeListener('nfc-data', handleNfcData)
    };
  }, [handleNfcData])

  const handleSubmit = (event) => {
    event.preventDefault()
    setTriggerLogin(true)
  }

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
      <div className="flex-1 flex flex-col">
      </div>
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
