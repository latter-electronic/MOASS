// pages/mozzy/MozzyQuizTodayPage.jsx
import React, { useState, useEffect } from 'react'
import quizData from '../../data/ajgag.json'

function Quiz() {
  const [currentQuiz, setCurrentQuiz] = useState(null)
  const [showAnswer, setShowAnswer] = useState(false)

  // 컴포넌트 마운트 시 새 퀴즈 자동 불러오기
  useEffect(() => {
    handleNewQuiz()
  }, [])

  const handleNewQuiz = () => {
    const randomIndex = Math.floor(Math.random() * quizData.problems.length)
    setCurrentQuiz(quizData.problems[randomIndex])
    setShowAnswer(false) // 새 퀴즈를 보여줄 때 정답 숨기기
  }

  return (
    <div className="flex flex-col items-center justify-center">
      <h1 className="text-xl font-bold mb-4">오늘의 퀴즈</h1>
      <div
        className="bg-white p-8 rounded-lg shadow-md flex-1"
        style={{ maxHeight: '400px', width: '650px' }}
      >
        {currentQuiz && (
          <div className="flex flex-col justify-between h-full">
            <div>
              <p className="text-lg font-semibold mb-2">Q. {currentQuiz.quiz}</p>
              {!showAnswer && (
                <button
                  onClick={() => setShowAnswer(true)}
                  className="bg-green-500 text-white font-bold py-2 px-4 rounded hover:bg-green-600 transition-colors"
                >
                  정답 보기
                </button>
              )}
              {showAnswer && (
                <div className="mt-4">
                  <p className="text-lg font-semibold">A.</p>
                  <ul>
                    {currentQuiz.answer.map((ans, index) => (
                      <p key={index} className="text-lg list-disc list-inside">
                        {ans}
                      </p>
                    ))}
                  </ul>
                </div>
              )}
            </div>
          </div>
        )}
      </div>
      <button
        onClick={handleNewQuiz}
        className="bg-cyan-500 text-white font-bold py-2 px-4 rounded hover:bg-blue-600 transition-colors mt-4 mr-8 self-end"
      >
        새 퀴즈 보기
      </button>
    </div>
  )
}

export default Quiz
