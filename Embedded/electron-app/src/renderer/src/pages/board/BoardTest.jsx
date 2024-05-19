import React from 'react';
import useGlobalStore from '../../stores/useGlobalStore';

export default function BoardTest() {
    const boardUrl = useGlobalStore(state => state.boardUrl);
    console.log(boardUrl);

    function goBack() {
        window.history.back();
    }

    return (
        <div className="w-screen h-screen bg-white">
            <iframe
                src="https://k10e203.p.ssafy.io/room/48?userId=1058706"
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
        </div>
    );
}
