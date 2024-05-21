// TagNFCPage.jsx
import React, { useState, useEffect, useCallback } from 'react'
import { useNavigate } from 'react-router-dom'
import AuthStore from '../../stores/AuthStore.js'
import { deviceLogin } from '../../services/deviceService.js'
import LeftArrow from '../../assets/left_arrow.png'
// import MozzyLogin from '../../assets/mozzy_login.png'
import MozzyHandshake from '../../assets/mozzy_handshake.gif';

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

  // const ipcLoginHandle = () => window.electron.ipcRenderer.send('login-success', 'login')

  const handleSuccessfulLogin = useCallback((accessToken, refreshToken, deviceId, cardSerialId) => {
    login(accessToken, refreshToken, deviceId, cardSerialId)
    localStorage.setItem('accessToken', accessToken)
    localStorage.setItem('refreshToken', refreshToken)
    localStorage.setItem('deviceId', deviceId)
    localStorage.setItem('cardSerialId', cardSerialId)

    navigate('/tagsuccess');
    setTimeout(() => {
      navigate('/');
    }, 2000);
    // ipcLoginHandle();
  }, [login, navigate]);

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
      handleLogin()
      setTriggerLogin(false)
    }
  }, [triggerLogin, handleLogin])

  useEffect(() => {
    window.electron.ipcRenderer.on('nfc-data', handleNfcData);
    return () => {
      window.electron.ipcRenderer.removeListener('nfc-data', handleNfcData)
    };
  }, [handleNfcData])

  const handleSubmit = (event) => {
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
      }, 10000)
      setTimeoutId(id)

      return () => clearTimeout(id)
    }
  }, [showForm])

  const handleInputChange = (setter) => (event) => {
    setter(event.target.value)
    clearTimeout(timeoutId)
    const id = setTimeout(() => {
      setShowForm(false)
    }, 10000)
    setTimeoutId(id)
  }

  return (
    <div className="flex flex-row justify-between h-dvh w-full p-12 text-center text-white">
      <div className="flex-1 flex flex-col">
        <div className='flex flex-row'>
          <img
          className="flex animate-bounce-left-right my-3 h-36 w-40"
          src={LeftArrow}
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
            src={MozzyHandshake}
            alt="Mozzy Login"
            className="cursor-pointer mt-20"
            onClick={handleImageClick}
          />
        )}
      </div>
    </div>
  );
}
