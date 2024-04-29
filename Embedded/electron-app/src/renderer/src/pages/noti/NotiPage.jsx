import NotiComponent from './NotiComponent.jsx'
import NotiMM from './NotiMMComponent.jsx'
import NotiGitlab from './NotiGitlabComponent.jsx'

import checkIcon from './testImg/check-icon.svg'
import mozzySleep from './testImg/mozzy-sleep.svg'

export default function NotiPage() {
    return (
        <div className="flex h-screen w-screen">
        {/* 왼쪽 섹션: 알림 목록 */}
        <div className="w-1/3 bg-navy p-6 flex flex-col">
          <div className="flex justify-between items-center mb-4">
            <h1 className="text-3xl font-medium text-white">알림 모아쓰</h1>
            {/* 모두 읽음 처리 버튼 */}
            <button className="flex items-center gap-2 mt-2">
              <img src={checkIcon} alt="Check Icon" className="w-6 h-6" />
              <span className="text-sm text-white">모두 읽음 처리</span>
            </button>
          </div>
          <div className="flex-grow overflow-auto mt-4">
            {/* 알림 컴포넌트들을 여기에 렌더링 */}
            <NotiMM />
            <NotiGitlab />
            {/* 여기에 추가 알림 컴포넌트들을 렌더링할 수 있습니다. */}
          </div>
        </div>
  
        {/* 오른쪽 섹션: 상세 페이지 */}
        <div className="w-2/3 bg-gray-800/50 p-6 flex justify-center items-center">
          <img src={mozzySleep} alt="모찌잠" className="size-80 opacity-50" />
        </div>
      </div>
    );
  }
  