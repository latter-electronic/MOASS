// pages/mozzy/MozzyLongSitPage.jsx
import React, { useState, useEffect } from 'react'
import MozzyModal from '../../components/modals/MozzyModal.jsx'

function LongSit({ isOpen, onClose }) {
    const handleModalClose = () => {
        onClose()        // 부모 컴포넌트의 onClose 콜백 실행
    }

    return (
        <MozzyModal isOpen={isOpen} onRequestClose={handleModalClose}>
            <div className="text-black">
                <div className="text-black">
                    <h2>오래 앉아 있었으니 스트레칭을 해주세요</h2>
                </div>
            </div>
        </MozzyModal>
    )
}
export default LongSit