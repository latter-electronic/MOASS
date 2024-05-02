import React from 'react';
import { useNavigate } from 'react-router-dom';

import headerIcon from '../../assets/images/board/board-header-icon.svg';
import gara from './test/gara.svg'

export default function BoardPage() {
    const navigate = useNavigate();

    const callTestFunction = () => {  // 개발용
        navigate(`/test`);
    };

    return(
        <div className="flex flex-col p-6 h-screen w-[91vw]">
            <div className="flex justify-start items-center mb-4 gap-2">
                <h1 className="text-4xl font-medium">이음보드</h1>
                <img src={headerIcon} alt="Board Header Icon" className="size-8 mt-1" />
            </div>
            <img src={gara} alt="가라이미지" className="mt-8" onClick={() => callTestFunction()} />
        </div>
    );
}
