// pages/mozzy/MozzyQuizTodayPage.jsx
import React from 'react';

const lunchItems = [
    { id: 1, title: "김치찌개", description: "매콤하고 깊은 맛의 김치찌개입니다." },
    { id: 2, title: "된장찌개", description: "구수한 된장의 풍미가 가득한 된장찌개입니다." },
    { id: 3, title: "제육볶음", description: "매콤한 양념으로 볶아낸 제육볶음입니다." },
];

function QuizToday() {
    return (
        <div className="p-4">
            <h2 className="text-lg font-bold mb-4">오늘의 점심 메뉴</h2>
            <ul>
                {lunchItems.map(item => (
                    <li key={item.id} className="mb-2">
                        <div className="font-semibold">{item.title}</div>
                        <div className="text-sm text-gray-600">{item.description}</div>
                        <button className="mt-2 py-1 px-3 bg-blue-500 hover:bg-blue-700 text-white rounded">더 보기</button>
                    </li>
                ))}
            </ul>
        </div>
    );
}

export default QuizToday;
