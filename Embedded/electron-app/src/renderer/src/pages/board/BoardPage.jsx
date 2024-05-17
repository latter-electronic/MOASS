import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { fetchBoards, createBoard } from '../../services/boardService';
import useGlobalStore from '../../stores/useGlobalStore';

import headerIcon from '../../assets/images/board/board-header-icon.svg';
import mainImg from '../../assets/images/board/board-main-image.svg';
import boardMozzy from '../../assets/images/board/board-mozzy-image.svg';

export default function BoardPage() {
    const navigate = useNavigate();
    const [boards, setBoards] = useState([]);
    const [isLoading, setIsLoading] = useState(true);
    const [error, setError] = useState(null);
    const [newBoardName, setNewBoardName] = useState('');

    const user = useGlobalStore(state => state.user);

    useEffect(() => {
        const loadBoards = async () => {
            try {
                const response = await fetchBoards();
                setBoards(response.data.data);
            } catch (err) {
                setError(err.message);
            } finally {
                setIsLoading(false);
            }
        };

        loadBoards();
    }, []);

    const callTestFunction = () => {
        navigate(`/board/test`);
    };

    const goToHistory = () => {
        console.log("Navigating to history");
        navigate(`/board/history`);
    };

    const handleCreateBoard = async () => {
        try {
            const response = await createBoard({ boardName: newBoardName }, user.userId);
            console.log("보드 생성 완료:", response.data);
            // 보드 목록을 다시 로드
            const boardsResponse = await fetchBoards();
            setBoards(boardsResponse.data.data);
        } catch (err) {
            console.error("보드 생성 실패:", err.message);
        }
    };

    if (isLoading) {
        return <div>로딩중...</div>;
    }

    if (error) {
        return <div>이음보드 페이지 로딩 실패😖: {error}</div>;
    }

    return (
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
                <div className="relative flex items-end">
                    <img 
                        src={mainImg} 
                        alt="보드 메인 이미지" 
                        className="ml-5 w-full h-auto"
                        onClick={() => callTestFunction()} 
                    />
                    {boards.length === 0 && (
                        <div className="absolute inset-0 flex flex-col justify-center items-center">
                            <div className="text-center text-2xl text-gray-500">
                                현재 생성된 이음보드가 없어요 :&lt;
                            </div>
                            <input
                                type="text"
                                value={newBoardName}
                                onChange={(e) => setNewBoardName(e.target.value)}
                                placeholder="보드 이름을 입력하세요"
                                className="mt-4 p-2 border rounded"
                            />
                            <button
                                onClick={handleCreateBoard}
                                className="mt-2 p-2 bg-blue-500 text-white rounded hover:bg-blue-600"
                            >
                                보드 생성하기
                            </button>
                        </div>
                    )}
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
