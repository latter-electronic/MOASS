import React, { useEffect } from 'react'
import { useNavigate } from 'react-router-dom' 
import useAuthStore from '../../stores/AuthStore.js'
import tagging_space from '../../assets/tag_nfc.png'

export default function TagNFC() {
  const navigate = useNavigate()

  const callTagSuccessFunction = () => {
    navigate(`/tagsuccess`)
  }
  const { login, isAuthenticated } = useAuthStore((state) => ({
    login: state.login,
    isAuthenticated: state.isAuthenticated
  }))

  useEffect(() => {
    const handleNfcData = (data) => {
      console.log('Received NFC data:', data)
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

    console.log(window.userAPI);
    window.userAPI?.onNfcData(handleNfcData)

    // 컴포넌트 언마운트 시에 이벤트 리스너 정리.
    return () => {
      window.userAPI?.removeNfcDataListener()
    }
  }, [login, navigate])

  return (
    <div className="flex flex-row justify-between h-dvh w-full p-12 text-center text-white">
      <div className="flex-1 flex items-center justify-center">
        <button
          onClick={() => callTagSuccessFunction()}
          className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-lg shadow-md transition duration-300 ease-in-out mb-4"
        >
          개발용 호출
        </button>
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
