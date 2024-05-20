import React, { useEffect } from 'react';
import mozzy from '../../assets/call_mozzy.svg';
import { useNavigate, useLocation } from 'react-router-dom';
import './CallAlertPage.css'; // CSS 파일 임포트

export default function CallAlertPage() {
  const navigate = useNavigate();
  const location = useLocation();

  const { message, senderName, senderProfile } = location.state || {
    message: '지수님 필드트립 관련 잠깐 로비로 나와주실 수 있으실까요?',
    senderName: '이정원(교육프로)',
    senderProfile: 'default_image_path', // default image
  };

  useEffect(() => {
    const timeout = setTimeout(() => {
      navigate(-1);
    }, 5000); // 5초 후에 navigate(-1) 호출

    return () => clearTimeout(timeout);
  }, [navigate]);

  const handlePageClick = () => { // 개발용 뒤로가기
    navigate(-1);
  };

  return (
    <div
      className="flex flex-row justify-between h-dvh w-full p-12 text-center text-white flash-animation"
      onClick={handlePageClick}
    >
      <div className="flex-1 flex items-start justify-start">
        <div className="bg-white rounded-full flex items-center px-4 py-2">
          <img
            className="size-12 rounded-full mr-3"
            src={senderProfile}
            alt="profile image"
          />
          <span className="text-xl text-black">{senderName}</span>
        </div>
      </div>
      <div className="flex-1 flex flex-col">
        <div className="flex-1 flex items-center justify-center">
          <div></div>
        </div>
        <div className="flex-1 flex items-center justify-center text-12xl font-bold">호출</div>
        <div className="flex-1 flex items-center justify-center">
          <div className="bg-opacity-50 py-2 px-4 rounded-full inline-block">
            <span>{message}</span>
          </div>
        </div>
      </div>
      <div className="flex-1 flex flex-col items-center justify-end">
        <img className="size-72" src={mozzy} alt="mozzy icon" />
      </div>
    </div>
  );
}
