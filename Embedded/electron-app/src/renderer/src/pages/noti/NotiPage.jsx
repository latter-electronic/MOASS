export default function NotiPage() {
    return (
      <div className="flex h-screen w-screen">

        {/* 왼쪽 섹션: 알림 목록 */}
        <div className="w-1/3 bg-navy p-6 flex flex-col">
          <h1 className="text-3xl font-medium text-white mb-4">알림 모아쓰</h1>
          {/* 알림 컴포넌트들을 여기에 렌더링 */}
          <div className="flex-grow overflow-auto">
            {/* 알림 컴포넌트 예시 */}
            <div className="flex items-center p-4 bg-gray-800 rounded-lg mb-2">
              <div className="flex-grow">
                <div className="text-white text-sm">프로젝트 상태</div>
                <div className="text-blue-300 text-xs">@hosun.hwang: 개발자님 코드를 확인해주세요.</div>
              </div>
              <div className="text-gray-400 text-xs">9:00</div>
            </div>
            {/* 추가 알림들을 여기에 렌더링 */}
          </div>
        </div>
  
        {/* 오른쪽 섹션: 상세 페이지 */}
        <div className="w-2/3 bg-gray-700 p-6 flex justify-center items-center">
          <div className="text-white text-3xl">상세 페이지</div>
        </div>
        
      </div>
    );
  }
  