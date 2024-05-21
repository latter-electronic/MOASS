export default function NotiSsafyComponent({ notice }) { // notice 객체를 prop으로 받음
    return (
        <div className="flex w-full items-center h-24 p-3 bg-primary/60 rounded-2xl overflow-hidden shadow-md mb-2 relative">
            <div className="flex-grow ml-3">
                <div className="flex items-baseline mb-1">
                    <span className="text-xl font-medium text-white mr-2">{notice.title} 등록되었어요!</span>
                    <span className="text-lg text-gray-400">{notice.date}</span>
                </div>
                <div className="text-white text-lg">
                    <span className="font-light">{notice.content}</span>
                </div>
            </div>
        </div>
    );
}
