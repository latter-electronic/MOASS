export default function NotiComponent() {
    return (
        <div className="flex items-center p-4 bg-gray-800 rounded-lg mb-2">
            <div className="flex-grow">
                <div className="text-white text-sm">프로젝트 상태</div>
                <div className="text-blue-300 text-xs">@hosun.hwang: 개발자님 코드를 확인해주세요.</div>
            </div>
            <div className="text-gray-400 text-xs">9:00</div>
        </div>
    );
}