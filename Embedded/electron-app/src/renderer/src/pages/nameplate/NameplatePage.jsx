// NamePlate.jsx
import { useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import ssafyLogo from './ssafyLogo.png';
import Status from './StatusComponent.jsx';
import useGlobalStore from '../../stores/useGlobalStore.js';
import AuthStore from '../../stores/AuthStore.js';

export default function NameplatePage() {
  const { user, fetchUserInfo, isLoadingUser, setUser } = useGlobalStore((state) => ({
    user: state.user,
    fetchUserInfo: state.fetchUserInfo,
    isLoadingUser: state.isLoadingUser,
    setUser: state.setUser,
  }));

  const { isAuthenticated, isCheckingAuth, checkStoredAuth, accessToken } = AuthStore((state) => ({
    isAuthenticated: state.isAuthenticated,
    isCheckingAuth: state.isCheckingAuth,
    checkStoredAuth: state.checkStoredAuth,
    accessToken: state.accessToken,
  }));

  const navigate = useNavigate();

  // 자동 로그인을 확인하고, 인증된 경우 사용자 정보를 가져옵니다.
  useEffect(() => {
    checkStoredAuth();
  }, [checkStoredAuth]);

  useEffect(() => {
    console.log(accessToken);
    if (!accessToken) {  
      navigate('/logoutnameplate');
    }
  }, [accessToken, navigate]);

  useEffect(() => {
    if (user?.statusId) {
      console.log('statusId changed:', user.statusId);
    }
  }, [user?.statusId]);

  useEffect(() => {
    if (isAuthenticated) {
      fetchUserInfo();
    }
  }, [isAuthenticated, fetchUserInfo]);

  // IPC를 통해 상태 업데이트를 처리합니다.
  useEffect(() => {
    window.electron.ipcRenderer.on('user-updated', (event, newUser) => {
      fetchUserInfo();
    });

    return () => {
      window.electron.ipcRenderer.removeAllListeners('user-updated');
    };
  }, [fetchUserInfo]);

  if (isCheckingAuth || isLoadingUser) {
    return <div className="5xl">로딩 중...</div>; // 인증 상태 확인 또는 사용자 정보 로딩 중
  }

  const positionColors = {
    FE: 'bg-rose-800',
    BE: 'bg-indigo-800',
    EM: 'bg-emerald-800',
    FULL: 'bg-yellow-800',
  };

  const positionBackground = user?.positionName ? positionColors[user.positionName] : 'bg-stone-400';

  const handlePageClick = () => {
    navigate(-1);
  };

  return (
    <div className="flex-grow bg-white" onClick={handlePageClick}>
      <div className="grid grid-cols-[1fr,3fr] w-full items-center h-screen">
        <div className="flex justify-center">
          <img src={ssafyLogo} alt="삼성 아카데미 로고" className="object-contain h-72 w-auto" />
        </div>

        <div className="flex flex-col justify-center">
          <div className="text-left">
            <div className="text-gray-400 font-normal text-6xl relative top-8 ml-10">
              {user?.teamCode} {user?.teamName}
            </div>
            <div className="flex">
              <div className="font-extrabold text-16xl tracking-wwww text-gray-900">{user?.userName}</div>
              <div className="flex flex-col justify-end">
                <button
                  className={`${positionBackground} text-white text-3xl font-semibold tracking-wider py-2 px-4 rounded-full mb-12`}
                >
                  {user?.positionName || 'Null'}
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div className="fixed inset-y-0 right-0">
        <Status statusId={user?.statusId} />
      </div>
    </div>
  );
}
