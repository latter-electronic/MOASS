import React, { useEffect } from 'react';
import tag_wave from '../../assets/tag_wave.svg';
import useGlobalStore from '../../stores/useGlobalStore';

export default function TagSuccess() {
  const { user, fetchUserInfo } = useGlobalStore(state => ({
    user: state.user,
    fetchUserInfo: state.fetchUserInfo
  }))

  useEffect(() => {
    if (!user) {
      fetchUserInfo()  // 사용자 정보가 없다면 정보를 불러온다.
    }
  }, [fetchUserInfo, user])

  const backgroundStyle = {
    backgroundImage: `url(${tag_wave})`,
    backgroundSize: 'cover',
    backgroundPosition: 'center',
    width: '100%',
    height: '100vh',
  };

  return (
    <div style={backgroundStyle} className="flex flex-row justify-between h-dvh w-full">
      <div className="flex flex-1 justify-center items-center text-8xl">
        {user ? <p>반갑습니다, {user.userName}님!</p> : <p>사용자 정보를 불러오는 중...</p>}
      </div>
    </div>
  )
}
