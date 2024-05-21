import React, { useEffect } from 'react';
import './TagSuccess.css'
import tag_wave from '../../assets/tag_wave.svg';
import useGlobalStore from '../../stores/useGlobalStore';

export default function TagSuccess() {
  const { user } = useGlobalStore((state) => ({ user: state.user }));

  const backgroundStyle = {
    backgroundImage: `url(${tag_wave})`,
    backgroundSize: 'cover',
    backgroundPosition: 'center',
    width: '100%',
    height: '100vh',
  };

  return (
    <div className="pulse-container">
      <div className="pulse" style={{ animationDelay: '-6s' }}></div>
      <div className="pulse" style={{ animationDelay: '-4s' }}></div>
      <div className="pulse" style={{ animationDelay: '-2s' }}></div>
      <div className="pulse" style={{ animationDelay: '0s' }}></div>
      <div className="flex flex-row justify-center items-center text-8xl w-full h-full z-50">
        {user ? <p>반갑습니다, {user.userName}님!</p> : <p>사용자 정보를 불러오는 중...</p>}
      </div>
    </div>
  );
}
