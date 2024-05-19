import ReactMarkdown from 'react-markdown';
import mattermostIcon from './testImg/mattermost-icon.svg';

export default function NotiDetailComponent({ notice, onClose }) {
  const { icon, title, body, sender, createdAt } = notice;

  return (
    <div className="flex flex-col w-full h-full items-center justify-start bg-white bg-opacity-80 rounded-lg shadow-lg text-gray-800 p-6 relative">
      {/* 배경 아이콘 */}
      <div className="absolute inset-0 z-0 opacity-10 flex justify-center items-center">
        <img src={mattermostIcon} alt="Mattermost Icon" className="w-3/4 h-3/4" />
      </div>
      {/* 상단 바: 아이콘, 프로필 및 시간 */}
      <div className="w-full flex items-center justify-between p-3 border-b bg-white bg-opacity-70 z-10 rounded-t-lg">
        <div className="flex items-center">
          <img src={icon} alt="Icon" className="w-10 h-10 rounded-full" />
          <div className="ml-4">
            <span className="font-semibold text-xl">{sender}</span>
            <div className="text-sm text-gray-500">{new Date(createdAt).toLocaleTimeString()}</div>
          </div>
        </div>
        <button onClick={onClose} className="ml-2 p-2 rounded-full hover:bg-gray-200">
          <span className="text-2xl">X</span>
        </button>
      </div>
      {/* 내용 영역 */}
      <div className="flex flex-col items-start justify-center flex-grow w-full p-5 z-10 bg-white bg-opacity-70 rounded-b-lg">
        <span className="text-2xl font-semibold mb-4">{title}</span>
        <ReactMarkdown className="text-lg text-left leading-relaxed">{body}</ReactMarkdown>
      </div>
    </div>
  );
}
