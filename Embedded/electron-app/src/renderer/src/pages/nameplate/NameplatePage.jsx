import React, { useEffect } from 'react';
import ssafyLogo from './ssafyLogo.png';
import Status from './StatusComponent.jsx';
import useGlobalStore from '../../stores/GlobalStore.js';

export default function NameplatePage() {
    // useGlobalStore 훅을 사용하여 스토어의 상태 및 액션에 접근
    const { user, fetchUserInfo } = useGlobalStore();

    useEffect(() => {
        fetchUserInfo(); // 컴포넌트 마운트 시 사용자 정보를 가져옴
    }, [fetchUserInfo]);

    if (!user) {
        return <div>로딩 중...</div>; // user 정보가 없을 경우 로딩 표시
    }

    return (
        <div className="flex-grow bg-white">
            <div className="grid grid-cols-[1fr,3fr] w-full items-center h-screen">
                <div className="flex justify-center">
                    <img src={ssafyLogo} alt="삼성 아카데미 로고" className="object-contain h-72 w-auto" />
                </div>

                <div className="flex flex-col justify-center">
                    <div className="text-left">
                        <div className="text-gray-400 font-normal text-6xl relative top-8 ml-10">{user.teamCode} 후자전자</div>
                        <div className="flex">
                            <div className="font-extrabold text-16xl tracking-wwww text-gray-900">{user.userName}</div>
                            <div className="flex flex-col justify-end">
                                {/* jobCode를 기반으로 버튼 레이블을 표시합니다. */}
                                <button className="bg-red-500 hover:bg-red-600 text-white text-2xl font-bold tracking-wider py-2 px-4 rounded-full mb-12">
                                    {user.jobCode === 1 ? 'FE' : 'BE'} {/* 예시로 FE 또는 BE 표시 */}
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div className="fixed inset-y-0 right-0">
                <Status />
            </div>
        </div>
    );
}
