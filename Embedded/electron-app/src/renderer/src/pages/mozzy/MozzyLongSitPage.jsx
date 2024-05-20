// pages/mozzy/MozzyLongSitPage.jsx
import React, { useState, useEffect } from 'react'
import MozzyModal from '../../components/modals/MozzyModal.jsx'

function LongSit({ isOpen, onClose }) {
    const handleModalClose = () => {
        onClose()        // 부모 컴포넌트의 onClose 콜백 실행
    }

    useEffect(() => {
        let timer;
        if (isOpen) {
            // 모달이 열렸을 때 6초 후에 닫히도록 타이머 설정
            timer = setTimeout(() => {
                onClose(); // 부모 컴포넌트의 onClose 콜백 실행
            }, 6000);
        }
        
        return () => {
            clearTimeout(timer);
        };
    }, [isOpen, onClose]);

    return (
        <MozzyModal isOpen={isOpen} onRequestClose={handleModalClose}>
            <div className="flex flex-col items-center justify-center text-black p-8">
                <p className="text-2xl font-bold mb-4">
                    알고 계셨나요?
                </p>
                <p className="text-2xl font-bold mb-4">
                    1시간에 한 번씩 스트레칭을 해주는게 좋답니다!
                </p>
            </div>
        </MozzyModal>
    )
}
export default LongSit