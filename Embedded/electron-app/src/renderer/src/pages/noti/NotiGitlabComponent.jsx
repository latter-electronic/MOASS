import gitlabIcon from './testImg/gitlab-icon.png';

export default function NotiGitlabComponent() {
    return (
      <div className="flex items-center p-3 bg-gitlabRed/60 rounded-2xl overflow-hidden shadow-md mb-2">
  
  
        {/* 알림 내용 */}
        <div className="flex-grow">
          <div className="flex items-baseline">
            <span className="text-sm font-medium text-white mr-2">[Gitlab] 알림</span>
            <span className="text-xs text-gray-400">오전 9:00</span>
          </div>
          <div className="text-white text-sm">
              <span className="font-light">한성주 pushed new branch EM/feat/sensors …</span>
          </div>
        </div>
  
        {/* Gitlab 로고 */}
        <div className="flex-shrink-0 ml-3">
          <img src={gitlabIcon} alt="Gitlab Icon" className="w-6 h-6 opacity-40" />
        </div>
  
      </div>
    );
  }
  