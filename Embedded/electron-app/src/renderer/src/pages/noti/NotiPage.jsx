import NotiComponent from './NotiComponent.jsx'
import NotiMM from './NotiMMComponent.jsx'

export default function NotiPage() {
    return (
      <div className="flex h-screen w-screen">

        {/* 왼쪽 섹션: 알림 목록 */}
        <div className="w-1/3 bg-navy p-6 flex flex-col">
          <h1 className="text-3xl font-medium text-white mb-4">알림 모아쓰</h1>
          {/* 알림 컴포넌트들을 여기에 렌더링 */}
          <div className="flex-grow overflow-auto">
            <NotiComponent />
            <NotiComponent />
            <NotiComponent />
            <NotiMM />
          </div>
        </div>
  
        {/* 오른쪽 섹션: 상세 페이지 */}
        <div className="w-2/3 bg-gray-800/50 p-6 flex justify-center items-center">
          <div className="text-white text-3xl">상세 페이지</div>
        </div>

      </div>
    );
  }
  