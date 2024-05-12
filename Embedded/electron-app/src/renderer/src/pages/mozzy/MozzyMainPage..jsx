// pages/mozzy/MozzyMainPage.jsx
import React, { useState } from 'react'
import useGlobalStore from '../../stores/useGlobalStore.js'
import MozzyModal from '../../components/modals/MozzyModal.jsx'
import LunchMenu from './MozzyLunchMenuPage.jsx'
import DailyNews from './MozzyDailyNewsPage.jsx'
import DailyScrum from './MozzyDailyScrumPage.jsx'
import QuizToday from './MozzyQuizTodayPage.jsx'

function MozzyMain({ isOpen, onClose }) {
    const [page, setPage] = useState('main')
    const { user } = useGlobalStore(state => ({
        user: state.user,
    }))

    const handleModalClose = () => {
        setPage('main')  // 모달을 닫을 때 페이지 상태를 초기화
        onClose()        // 부모 컴포넌트의 onClose 콜백 실행
    }

    const renderContent = () => {
        switch (page) {
            case 'lunch':
                return <LunchMenu />
            case 'news':
                return <DailyNews />
            case 'scrum':
                return <DailyScrum />
            case 'quiz':
                return <QuizToday />
            default:
                return (
                    <div>
                        <div className='flex flex-col justify-center items-center text-2xl'>
                            <p>안녕하세요, {user.userName} 님!</p>
                            <p>제가 도와드릴 일이 있을까요?</p>
                        </div>
                        <div className='flex flex-row justify-between mt-5 mx-3'>
                            <button
                                className="bg-blue-500 text-white font-bold py-2 px-4 rounded"
                                onClick={() => setPage('lunch')}>점심 메뉴</button>
                            <button 
                            className="bg-blue-500 text-white font-bold py-2 px-4 rounded"
                            onClick={() => setPage('news')}>오늘의 뉴스</button>
                            <button 
                            className="bg-blue-500 text-white font-bold py-2 px-4 rounded"
                            onClick={() => setPage('scrum')}>데일리 스크럼 정리</button>
                            <button 
                            className="bg-blue-500 text-white font-bold py-2 px-4 rounded"
                            onClick={() => setPage('quiz')}>오늘의 퀴즈</button>
                        </div>
                    </div>
                )
        }
    }

    return (
        <MozzyModal isOpen={isOpen} onRequestClose={handleModalClose}>
            <div className="p-3 text-black">
                {renderContent()}
            </div>
        </MozzyModal>
    );
}

export default MozzyMain
