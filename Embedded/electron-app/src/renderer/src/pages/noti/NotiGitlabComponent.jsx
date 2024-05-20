import gitlabIcon from './testImg/gitlab-icon.png';

export default function NotiGitlabComponent() {
  return (
    <div className="flex items-center h-24 p-3 bg-gitlabRed/60 rounded-2xl overflow-hidden shadow-md mb-2 relative">


      {/* 알림 내용 */}
      <div className="flex-grow ml-3">
        <div className="flex items-baseline">
          <span className="text-xl font-medium text-white mr-2">[Gitlab] 알림</span>
          <span className="text-lg text-gray-400">오전 9:00</span>
        </div>
        <div className="text-white text-lg">
          <span className="font-light">한성주 pushed new branch EM/feat/sensors …</span>
        </div>
      </div>

      {/* Gitlab 로고 */}
      <div className="flex-shrink-0 mr-1 absolute top-5 right-3">
        <img src={gitlabIcon} alt="Gitlab Icon" className="size-14 opacity-30" />
      </div>

    </div>
  );
}
