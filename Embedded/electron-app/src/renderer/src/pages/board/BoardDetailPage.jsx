import React, { useState } from 'react';
import { exitBoard } from '../../services/boardService';
import useGlobalStore from '../../stores/useGlobalStore';

export default function BoardTest() {
    const boardUrl = useGlobalStore(state => state.boardUrl);
    console.log(boardUrl);

    const [isModalOpen, setIsModalOpen] = useState(false);

    const goBack = async() => {
        //가져온 보드 URL 안에서 id와 유저 ID를 나가기 API에 요청
        // localStorage에서 userId 가져오기
        const userId = localStorage.getItem('userId');
        const boardId = boardUrl.boardId
        try {
            await exitBoard(userId, boardId);
            console.log("보드 나가기 완료:");
            window.history.back();
        } catch (err) {
            console.error("보드 나가기 실패:", err.message);
        }
    }

    function handleSaveImage() {
        setIsModalOpen(true);
        setTimeout(() => {
            setIsModalOpen(false);
        }, 2000); // 모달을 2초 후에 자동으로 닫기
    }

    return (
        <div className="relative w-screen h-screen bg-white">
            <iframe
                src={boardUrl}
                title="Embedded Board"
                className="w-full h-full bg-white"
                allowFullScreen
            ></iframe>
            <button 
                onClick={goBack} 
                className="absolute top-5 ml-20 z-10 text-white bg-blue-500 hover:bg-blue-700 font-medium py-2 px-4 rounded"
            >
                뒤로 가기
            </button>
            <button 
                onClick={handleSaveImage} 
                className="absolute bottom-5 left-5 z-10 text-white font-medium py-2 px-4 rounded"
            >
                이미지 저장
            </button>
            {isModalOpen && (
                <div className="absolute inset-0 flex items-center justify-center bg-white/80">
                    <div className="text-white text-2xl p-4 rounded-lg bg-green-400">
                        이미지가 저장되었어요!
                    </div>
                </div>
            )}
        </div>
    );
}
