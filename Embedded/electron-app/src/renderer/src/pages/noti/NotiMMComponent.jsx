import teamIcon from './testImg/team-icon.png';
import mattermostIcon from './testImg/mattermost-icon.svg';

export default function NotiMMComponent() {
  return (
    <div className="flex items-center p-3 bg-mmBlue rounded-lg overflow-hidden shadow-md">
        
      {/* 팀 아이콘 */}
      <div className="flex-shrink-0 mr-3">
        <img src={teamIcon} alt="Team Icon" className="w-10 h-10 rounded-full" />
      </div>

      {/* 알림 내용 */}
      <div className="flex-grow">
        <div className="flex items-baseline">
          <span className="text-sm font-medium text-white mr-2">긴급시안함</span>
          <span className="text-xs text-gray-400">오전 9:00</span>
        </div>
        <div className="text-blue-300 text-sm">
          @hosun.hwang: 개발자님 코드를 검사했습니다.
        </div>
      </div>

      {/* Mattermost 로고 */}
      <div className="flex-shrink-0 ml-3">
        <img src={mattermostIcon} alt="Mattermost Icon" className="w-6 h-6" />
      </div>

    </div>
  );
}
