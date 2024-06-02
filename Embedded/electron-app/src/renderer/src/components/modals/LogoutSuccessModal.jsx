import React, { useEffect, useState } from 'react';

export default function LogoutSuccessModal({ onClose }) {
  const [secondsLeft, setSecondsLeft] = useState(3);

  useEffect(() => {
    if (secondsLeft === 0) {
      onClose();
      return;
    }
    const timer = setInterval(() => {
      setSecondsLeft((prev) => prev - 1);
    }, 1000);

    return () => clearInterval(timer);
  }, [secondsLeft, onClose]);

  return (
    <div className="fixed inset-0 flex items-center justify-center z-50 bg-black bg-opacity-50">
      <div className="bg-white p-7 rounded-lg shadow-lg text-zinc-900">
        <h2 className="text-xl font-bold mb-4">로그아웃 성공!</h2>
        <p className="text-lg mb-4">다음에도 모아쓰와 함께해주세요🖐🏻</p>
        <div className="flex justify-center mt-6">
          <button
            className="bg-green-100 text-lg hover:bg-green-700 text-green-600 font-semibold py-2 px-4 rounded-2xl flex-grow"
            onClick={onClose}
          >
            {secondsLeft}초 후 자동으로 닫힘
          </button>
        </div>
      </div>
    </div>
  );
}
