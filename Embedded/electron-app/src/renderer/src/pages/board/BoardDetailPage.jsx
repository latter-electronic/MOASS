import React, { useEffect, useRef, useState } from 'react';
import { exitBoard } from '../../services/boardService';
import useGlobalStore from '../../stores/useGlobalStore';

const BoardIframe = ({ boardUrl, userId, boardId }) => {
  const iframeRef = useRef(null);

  useEffect(() => {
    const iframe = iframeRef.current;

    const handleIframeLoad = () => {
      const data = { userId, boardId };
      iframe.contentWindow.postMessage(data, "https://k10e203.p.ssafy.io");
    };

    if (iframe) {
      iframe.addEventListener('load', handleIframeLoad);
    }

    return () => {
      if (iframe) {
        iframe.removeEventListener('load', handleIframeLoad);
      }
    };
  }, [boardUrl, userId, boardId]);

  return (
    <iframe
      ref={iframeRef}
      src={boardUrl}
      style={{ width: '100%', height: '100%', border: 'none' }}
      title="Embedded Board"
    ></iframe>
  );
};

export default function BoardDetailPage() {
  const boardUrl = useGlobalStore(state => state.boardUrl);
  console.log(boardUrl);

  const [isModalOpen, setIsModalOpen] = useState(false);

  const goBack = async () => {
    // localStorage에서 userId와 boardId 가져오기
    const userId = localStorage.getItem('userId');
    const boardId = localStorage.getItem('boardId');
    try {
      await exitBoard(userId, boardId);
      console.log("보드 나가기 완료:");
      window.history.back();
    } catch (err) {
      console.error("보드 나가기 실패:", err.message);
    }
  };

  function handleSaveImage() {
    setIsModalOpen(true);
    setTimeout(() => {
      setIsModalOpen(false);
    }, 2000); // 모달을 2초 후에 자동으로 닫기
  }

  return (
    <div className="relative w-screen h-screen bg-white">
      <BoardIframe
        boardUrl={boardUrl}
        userId={localStorage.getItem('userId')}
        boardId={localStorage.getItem('boardId')}
      />
      <button 
        onClick={goBack} 
        className="absolute top-5 ml-20 z-10 text-white bg-blue-500 hover:bg-blue-700 font-medium py-2 px-4 rounded"
      >
        뒤로 가기
      </button>
      {/* <button 
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
      )} */}
    </div>
  );
}
