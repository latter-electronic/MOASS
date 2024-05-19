import teamIcon from './testImg/team-icon.png';
import mattermostIcon from './testImg/mattermost-icon.svg';

export default function NotiMMComponent({ notice }) {
  const { icon, title, body, sender, createdAt } = notice;

  const truncateBody = (text, maxLength) => {
    if (text.length > maxLength) {
      return text.substring(0, maxLength) + '...';
    }
    return text;
  };

  return (
    <div className="flex h-24 items-center p-3 bg-mmBlue/60 rounded-2xl overflow-hidden shadow-md mb-2 relative w-full">
      {/* 팀 아이콘 */}
      <div className="flex-shrink-0 ml-1 mr-4 bg-white rounded-md">
        <img src={icon} alt="Team Icon" className="size-14 rounded-full" />
      </div>

      {/* 알림 내용 */}
      <div className="flex-grow">
        <div className="flex items-baseline">
          <span className="text-xl font-medium text-white mr-2">{title}</span>
          <span className="text-lg text-gray-400">{new Date(createdAt).toLocaleTimeString()}</span>
        </div>
        <div className="text-white text-lg overflow-hidden" style={{ textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
          <span className="font-medium">@{sender}: </span>
          <span className="font-light">{truncateBody(body, 8)}</span>
        </div>
      </div>

      {/* Mattermost 로고 */}
      <div className="flex-shrink-0 mr-1 absolute top-5 right-3">
        <img src={mattermostIcon} alt="Mattermost Icon" className="size-14 opacity-15" />
      </div>
    </div>
  );
}
