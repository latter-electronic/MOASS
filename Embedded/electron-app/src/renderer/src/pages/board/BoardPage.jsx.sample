import React from 'react';
import headerIcon from '../../assets/images/board/board-header-icon.svg';
import createIcon from '../../assets/images/board/board-create-icon.svg';
import participateIcon from '../../assets/images/board/board-participate-icon.svg';

export default function BoardPage() {
    return(
        <div className="p-6 h-screen w-[91vw]">
            <div className="flex justify-start items-center mb-4 gap-2">
                <h1 className="text-4xl font-medium">이음보드</h1>
                <img src={headerIcon} alt="Board Header Icon" className="size-8 mt-1" />
            </div>
            <div className="grid grid-cols-2 gap-10 mt-14 ml-6">
                <div className="flex flex-col gap-8 items-center justify-center h-96 bg-cyan-200/40 rounded-2xl p-4 shadow-lg border-2 border-dashed border-white/45">
                    <img src={createIcon} alt="Create Board Icon" className="mb-2 opacity-50" />
                    <button className="text-white/75 text-2xl font-normal">이음보드 생성하기</button>
                </div>
                <div className="flex flex-col gap-8 items-center justify-center bg-pink-200/40 rounded-2xl p-4 shadow-lg border-2 border-dashed border-white/45">
                    <img src={participateIcon} alt="Participate Icon" className="mb-2 opacity-50" />
                    <button className="text-white/75 text-2xl font-normal">이음보드 참여하기</button>
                </div>
            </div>
        </div>
    );
}
