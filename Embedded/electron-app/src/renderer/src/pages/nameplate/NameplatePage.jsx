import ssafyLogo from './ssafyLogo.png';
import Status from './StatusComponent.jsx';

export default function NameplatePage() {
    return (
        <div className="flex-grow bg-white text-black">
            <div className="grid grid-cols-[1fr,3fr] w-full items-center h-screen">
                {/* 로고 영역 */}
                <div className="flex justify-center">
                    <img src={ssafyLogo} alt="삼성 아카데미 로고" className="object-contain h-72 w-auto" />
                </div>

                {/* 중앙 텍스트 영역 */}
                <div className="flex flex-col justify-center">
                    <div className="text-left">
                        <div className="text-gray-400 font-normal text-6xl relative top-8 ml-10">E203 후자전자</div>
                        <div className="flex">
                            <div className="font-extrabold text-16xl tracking-wwww text-gray-900">서지수</div>
                            <div className="flex flex-col justify-end">
                                <button className="bg-red-500 hover:bg-red-600 text-white text-2xl font-bold tracking-wider py-2 px-4 rounded-full mb-12">
                                    FE
                                </button>
                            </div>
                        </div>

                    </div>
                </div>

                {/* FE 버튼 영역 */}

            </div>
            <div className="fixed inset-y-0 right-0">
                <Status />
            </div>
        </div>
    );
}
