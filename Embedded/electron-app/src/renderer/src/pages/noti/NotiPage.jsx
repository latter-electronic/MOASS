import NotiComponent from './NotiComponent.jsx'
import NotiMM from './NotiMMComponent.jsx'
import NotiGitlab from './NotiGitlabComponent.jsx'
import NotiSsafy from './NotiSsafyComponent.jsx'

import checkIcon from './testImg/check-icon.svg'
import mozzySleep from './testImg/mozzy-sleep.svg'


export default function NotiPage() {
  const notices = [{
    id: 1,
    title: '설문이',
    content: '(240503) 10기 자율프로젝트 4주차 만족도 설문',
    date: '오후 6:00'
  },
  {
    id: 2,
    title: '공지가',
    content: '[운영] 2학기 자율프로젝트 4주차 안내',
    date: '오후 4:00'
  }, {
    id: 3,
    title: '설문이',
    content: '(240503) 10기 자율프로젝트 4주차 만족도 설문',
    date: '오후 6:00'
  },
  {
    id: 4,
    title: '공지가',
    content: '[운영] 2학기 자율프로젝트 4주차 안내',
    date: '오후 4:00'
  }]

  return (
    <div className="flex h-screen">

      {/* 왼쪽 섹션: 알림 목록 */}
      <div className="w-1/3 bg-navy p-6 flex flex-col">
        <div className="flex justify-between items-center mb-4">
          <h1 className="text-4xl font-medium text-white">알림 모아쓰</h1>
          {/* 모두 읽음 처리 버튼 */}
          <button className="flex items-center gap-2 mt-3">
            <img src={checkIcon} alt="Check Icon" className="w-6 h-6" />
            <span className="text-lg text-white">모두 읽음 처리</span>
          </button>
        </div>
        <div className="flex-grow overflow-auto mt-4 scrollbar-hide">
          {/* 알림 컴포넌트들을 여기에 렌더링 */}
          <NotiMM />
          <NotiGitlab />
          {notices.map((notice) => (
            <NotiSsafy key={notice.id} notice={notice} />
          ))}
        </div>
      </div>

      {/* 오른쪽 섹션: 상세 페이지 */}
      <div className="flex flex-col w-2/3 bg-gray-800/50 p-6 justify-center text-center items-center">
        <div className="mb-4">
          <img src={mozzySleep} alt="모찌잠" className="ml-16 size-80 opacity-50" />
          <span className="text-2xl text-primary/60">현재는 고정된 알림이 없어요</span>
        </div>
      </div>
    </div>
  );
}
