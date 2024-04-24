import Clock from './HomeClockComponent.jsx'
import Calendar from './CalendarWidget.jsx'
import TodoList from './HomeTodoListComponent.jsx'
import Schedule from './HomeScheduleComponent.jsx'

import Mozzy from '../../assets/Mozzy.svg'

export default function HomePage() {
    return (
        <div className="container mx-auto p-4 h-screen">
            {/* 전체 레이아웃을 3열로 분할하고, 각 열을 화면 높이와 동일하게 설정 */}
            <div className="grid grid-cols-3 gap-8 h-full">
                {/* 1열: 시계, 달력 위아래로 배치 */}
                <div className="flex flex-col justify-between">
                    <Clock />
                    <div className="flex justify-start">
                    <Calendar />
                    </div>
                </div>
                {/* 2열: 스케줄러만 중앙에 */}
                <div className="flex flex-col justify-center">
                    <Schedule />
                </div>
                {/* 3열: 할 일 목록, 모찌 위아래로 배치 */}
                <div className="flex flex-col justify-center items-end mr-6 h-full">
                    <TodoList />
                    <div className="mt-8">
                        <img src={Mozzy} alt="Mozzy" className="size-64"/>
                    </div>
                </div>
            </div>
        </div>
    );
}
