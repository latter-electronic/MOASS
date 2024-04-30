import teamIcon from './testImg/team-icon.png';
import mattermostIcon from './testImg/mattermost-icon.svg';

export default function NotiMMComponent() {
  return (
    <div className="flex h-20 items-center p-3 bg-mmBlue/60 rounded-2xl overflow-hidden shadow-md mb-2">

      {/* 팀 아이콘 */}
      <div className="flex-shrink-0 ml-1 mr-4 bg-white rounded-md">
        <img src={teamIcon} alt="Team Icon" className="w-12 h-12 rounded-full" />
      </div>

      {/* 알림 내용 */}
      <div className="flex-grow">
        <div className="flex items-baseline">
          <span className="text-base font-medium text-white mr-2">공지사항</span>
          <span className="text-sm text-gray-400">오전 9:00</span>
        </div>
        <div className="text-white text-base">
            <span className="font-medium">@hosun.hwang: </span>
            <span className="font-light">가 메세지를 게시했습니다.</span>
        </div>
      </div>

      {/* Mattermost 로고 */}
      <div className="flex-shrink-0 mr-1">
        <img src={mattermostIcon} alt="Mattermost Icon" className="size-10 opacity-20" />
      </div>

    </div>
  );
}
