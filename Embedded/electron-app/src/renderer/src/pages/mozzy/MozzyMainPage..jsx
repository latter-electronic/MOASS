// pages/mozzy/MozzyMainPage.jsx
import React, { useState, useEffect } from 'react'
import useGlobalStore from '../../stores/useGlobalStore.js'
import MozzyModal from '../../components/modals/MozzyModal.jsx'
import LunchMenu from './MozzyLunchMenuPage.jsx'
import DailyNews from './MozzyDailyNewsPage.jsx'
import DailyScrum from './MozzyDailyScrumPage.jsx'
import QuizToday from './MozzyQuizTodayPage.jsx'
import useLunchMenuStore from '../../stores/LunchMenuStore'
import BackButton from '../../components/buttons/BackButton.jsx'

function MozzyMain({ isOpen, onClose }) {
    const [page, setPage] = useState('main')
    const { user } = useGlobalStore(state => ({
        user: state.user,
    }))
    const { lunchMenus, fetchLunchMenus, isLoading, error } = useLunchMenuStore(state => ({
        lunchMenus: state.launchMenus, 
        fetchLunchMenus: state.fetchLunchMenus, 
        isLoading: state.isLoading, 
        error: state.error
    }))

    useEffect(() => {
        fetchLunchMenus() // 컴포넌트 마운트 시 메뉴 데이터 불러오기
    }, [])

    const handleModalClose = () => {
        setPage('main')  // 모달을 닫을 때 페이지 상태를 초기화
        onClose()        // 부모 컴포넌트의 onClose 콜백 실행
    }

    const renderContent = () => {
        switch (page) {
            case 'lunch':
                return <LunchMenu />
            case 'quiz':
                return <QuizToday />
            case 'news':
                return <DailyNews />
            case 'scrum':
                return <DailyScrum />
            default:
                return (
                    <div className='flex flex-col'>
                        <div className='flex flex-col justify-center items-center text-2xl my-5'>
                            <p>안녕하세요, {user?.userName} 님!</p>
                            <p>제가 도와드릴 일이 있을까요?</p>
                        </div>
                        <div className='flex flex-row justify-between my-3 mx-3'>
                            <button
                                className="bg-cyan-500 text-white font-bold py-2 px-4 rounded"
                                onClick={() => setPage('lunch')}>점심 메뉴</button>
                            <button 
                                className="bg-cyan-500 text-white font-bold py-2 px-4 rounded"
                                onClick={() => setPage('quiz')}>오늘의 퀴즈</button>
                            <button 
                                className="bg-cyan-500 text-white font-bold py-2 px-4 rounded"
                                onClick={() => setPage('news')}>오늘의 뉴스</button>
                            <button 
                                className="bg-cyan-500 text-white font-bold py-2 px-4 rounded"
                                onClick={() => setPage('scrum')}>데일리 스크럼</button>
                        </div>
                    </div>
                )
        }
    }

    return (
        <MozzyModal isOpen={isOpen} onRequestClose={handleModalClose}>
            <div className="text-black">
                {page !== 'main' && (
                    <BackButton
                        onClick={() => setPage('main')}
                        className="absolute top-2 left-3 bg-gray-300 text-gray-700 font-bold py-2 px-4 rounded"
                    >
                    </BackButton>
                )}
                {renderContent()}
            </div>
        </MozzyModal>
    );
}

export default MozzyMain
