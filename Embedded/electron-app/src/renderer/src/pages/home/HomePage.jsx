import { useNavigate } from 'react-router-dom';

import Clock from './HomeClockComponent.jsx'
import Calendar from './CalendarWidget.jsx'
import TodoList from './HomeTodoListComponent.jsx'
import Schedule from './HomeScheduleComponent.jsx'

import Mozzy from '../../assets/Mozzy.svg'
import { Swiper, SwiperSlide } from 'swiper/react';

// Import Swiper styles
import 'swiper/css';
import 'swiper/css/pagination';

import { Pagination } from 'swiper/modules';


export default function HomePage() {
    const navigate = useNavigate();

    const callAlertFunction = () => {  // 개발용
        navigate(`/callalert`);
    };

    const callNamePlateFunction = () => {  // 개발용
        navigate(`/nameplate`);
    };

    return (
        <div className=" mx-auto p-4 h-screen">
            {/* 전체 레이아웃을 3열로 분할하고, 각 열을 화면 높이와 동일하게 설정 */}
            <div className="grid grid-cols-[0.5fr,2.5fr,1fr] gap-8 h-full">
                {/* 1열: 시계, 달력 위아래로 배치 */}
                <div className="ml-1 flex flex-col gap-32 space-y-8">
                    <div onClick={() => callAlertFunction()}>
                    <Clock />
                    </div>
                    <div className="flex h-60 w-56 justify-center p-4 ml-3 bg-primary/20" >
                    <Swiper
                            pagination={{
                                dynamicBullets: true,
                            }}
                            modules={[Pagination]}
                            className="mySwiper"
                        >
                            <SwiperSlide>Slide 1</SwiperSlide>
                            <SwiperSlide>Slide 2</SwiperSlide>
                            <SwiperSlide>Slide 3</SwiperSlide>
                        </Swiper>
                    </div>
                </div>
                {/* 2열: 스케줄러만 중앙에 */}
                <div className="flex flex-col justify-center">
                    <Schedule />
                </div>
                {/* 3열: 할 일 목록, 모찌 위아래로 배치 */}
                <div className="flex flex-col justify-center items-end mr-8 h-full">
                    <TodoList />
                    <div className="mt-8">
                        <img src={Mozzy} alt="Mozzy" className="size-64" onClick={() => callNamePlateFunction()} />
                    </div>
                </div>
            </div>
        </div>
    );
}
