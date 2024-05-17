import { useNavigate } from 'react-router-dom'

import headerIcon from '../../assets/images/board/board-header-icon.svg';
import mainImg from '../../assets/images/board/board-main-image.svg';
import boardMozzy from '../../assets/images/board/board-mozzy-image.svg'

export default function BoardPage() {
    const navigate = useNavigate();

    const callTestFunction = () => {
        navigate(`/board/test`);
    };

    const goToHistory = () => {
        console.log("Navigating to history");

        navigate(`/board/history`);
    };

    return(
        <div className="flex flex-col p-6 h-screen">
            <div className="flex justify-between items-center mb-4">
                <div className="flex items-center gap-2">
                    <h1 className="text-4xl font-medium">이음보드</h1>
                    <img src={headerIcon} alt="Board Header Icon" className="w-8 h-8 mt-1" />
                </div>
                <span 
                    className="text-2xl cursor-pointer text-gray-500 hover:text-primary/70 mt-2 mr-14 underline underline-offset-4"
                    onClick={goToHistory}
                >
                    이전 기록 보기 &gt;&gt;
                </span>
            </div>
            <div className="grid grid-cols-[3fr,1fr] h-11/12">
                <div className="flex items-end">
                    <img 
                        src={mainImg} 
                        alt="보드 메인 이미지" 
                        className="ml-5 w-full h-auto"
                        onClick={() => callTestFunction()} 
                    />
                </div>
                <div className="flex items-end">
                    <img 
                        src={boardMozzy} 
                        alt="보드 모찌 이미지" 
                        className="w-11/12"
                    />
                </div>
            </div>
        </div>
    );
}
