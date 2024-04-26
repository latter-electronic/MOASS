import React from 'react'
import { useNavigate } from 'react-router-dom'
import tagging_space from '../../assets/tag_nfc.png'

export default function TagNFC() {
  const navigate = useNavigate()

  const callTagSuccessFunction = () => {
    navigate(`/tagsuccess`)
  }

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
