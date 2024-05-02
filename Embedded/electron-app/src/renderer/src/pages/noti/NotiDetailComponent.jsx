import profileImg from './testImg/profile.png'

export default function NotiDetailComponent() {
    return (
        <div className="flex flex-col w-full h-full items-center justify-center bg-white rounded-lg shadow  text-gray-800">
            {/* 상단 바: 프로필 및 시간 */}
            <div className="w-full flex items-center justify-between p-3 border-b">
                <div className="flex items-center">
                    <img src={profileImg} alt="Profile" className="w-10 h-10 rounded-full" />
                    <span className="ml-2 font-semibold">이정원(교육프로)</span>
                </div>
                <span className="text-sm text-gray-500">오후 2:56</span>
            </div>
            {/* 내용 영역 */}
            <div className="flex flex-col items-center justify-center flex-grow w-full p-5">
                <span className="text-lg text-center">content area</span>
            </div>
        </div>
    );
}
