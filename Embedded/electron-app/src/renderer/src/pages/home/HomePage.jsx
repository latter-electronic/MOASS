import { useNavigate } from 'react-router-dom';
import { useEffect, useState } from 'react';

import Clock from './HomeClockComponent.jsx'
import Calendar from './CalendarWidget.jsx'
import TodoList from './HomeTodoListComponent.jsx'
import Schedule from './HomeScheduleComponent.jsx'
import MozzyModal from '../mozzy/MozzyMainPage..jsx'
import LongSitModal from '../mozzy/MozzyLongSitPage.jsx'
import { updateUserStatus } from '../../services/userService.js'
import useGlobalStore from '../../stores/useGlobalStore.js'

import testImg1 from './test/swiper-slide-test-img-1.png'
import testImg2 from './test/swiper-slide-test-img-2.jpg'
import Mozzy from '../../assets/Mozzy.svg'
import { Swiper, SwiperSlide } from 'swiper/react';

// Import Swiper styles
import 'swiper/css';
import 'swiper/css/pagination';

import { Pagination } from 'swiper/modules';
import AuthStore from '../../stores/AuthStore.js';
import { getCurrentUser } from '../../services/jiraService.js'

export default function HomePage() {
    const [modalIsOpen, setModalIsOpen] = useState(false);
    const [longSitModalIsOpen, setLongSitModalIsOpen] = useState(false);
    const navigate = useNavigate();
    const { checkStoredAuth, isAuthenticated } = AuthStore((state) => ({
        checkStoredAuth: state.checkStoredAuth,
        isAuthenticated: state.isAuthenticated
    }));

    const { user, setUser } = useGlobalStore((state) => ({
        user: state.user,
        setUser: state.setUser,
    }));

    const openModal = () => {
        setModalIsOpen(true);
    };

    const closeModal = () => {
        setModalIsOpen(false);
    };

    const openLongSitModal = () => {
        setLongSitModalIsOpen(true);
    };

    const closeLongSitModal = () => {
        setLongSitModalIsOpen(false);
    };

    const callAlertFunction = () => {  // 개발용
        navigate(`/callalert`);
    };

    useEffect(() => {
        console.log('홈에서 확인중');
        checkStoredAuth();
        getCurrentUser();
    }, []);

    useEffect(() => {
        const handleMotionDetected = (event, data) => {
            if (data.status === 'LONG_SIT') {
                console.log("Long Sit");
                openLongSitModal();
            } else if (data.status === 'AWAY' || data.status === 'STAY') {
                const newStatus = data.status === 'AWAY' ? '0' : '1';
                console.log("New status: ", newStatus);

                if (newStatus !== user.statusId.toString()) {
                    updateUserStatus({ statusId: newStatus })
                        .then(() => {
                            console.log(`User status updated to ${data.status}`);
                            setUser({ ...user, statusId: parseInt(newStatus) });
                        })
                        .catch(error => {
                            console.error('Error updating user status:', error);
                        });
                }
            }
        };

        if (window.electron && window.electron.ipcRenderer) {
            window.electron.ipcRenderer.on('motion-detected', handleMotionDetected);
        } else {
            console.error("ipcRenderer is not available");
        }

        return () => {
            if (window.electron && window.electron.ipcRenderer) {
                window.electron.ipcRenderer.removeListener('motion-detected', handleMotionDetected);
            }
        };
    }, [user, setUser]);

    useEffect(() => {
        const { accessToken, refreshToken } = AuthStore.getState();
        console.log('AccessToken:', accessToken);
        console.log('RefreshToken:', refreshToken);
        if (!accessToken) {
            navigate('/login');
        } else if (window.electron && window.electron.ipcRenderer) {
            window.electron.ipcRenderer.send('login-success', 'login');
        }
    }, [navigate]);

    return (
        <div className="mx-auto p-4 h-screen">
            <div className="grid grid-cols-[0.5fr,2.5fr,1fr] gap-8 h-full">
                <div className="ml-1 flex flex-col space-y-8 gap-8">
                    <div onClick={() => callAlertFunction()}>
                        <Clock />
                    </div>
                    <div className="flex h-80 w-56 justify-center ml-3">
                        <Swiper
                            style={{
                                "--swiper-theme-color": "#6ECEF5",
                                "--swiper-pagination-bullet-inactive-color": "#FFFFFF",
                                "--swiper-pagination-bullet-width": "12px",
                                "--swiper-pagination-bullet-height": "12px",
                                display: 'flex',
                                flexDirection: 'column'
                            }}
                            pagination={{
                                dynamicBullets: true,
                            }}
                            modules={[Pagination]}
                            className="mySwiper"
                        >
                            <SwiperSlide style={{ display: 'flex', flexDirection: 'column', justifyContent: 'flex-end', marginBottom: '2.5rem' }}><Calendar /></SwiperSlide>
                            <SwiperSlide style={{ display: 'flex', flexDirection: 'column', justifyContent: 'flex-end', marginBottom: '2.5rem' }}><img src={testImg1} alt="테스트이미지1" className="mb-14 rounded-md" /></SwiperSlide>
                            <SwiperSlide style={{ display: 'flex', flexDirection: 'column', justifyContent: 'flex-end', marginBottom: '2.5rem' }}><img src={testImg2} alt="테스트이미지2" className="mb-14 rounded-md" /></SwiperSlide>
                        </Swiper>
                    </div>
                </div>
                <div className="flex flex-col justify-center">
                    <Schedule />
                </div>
                <div className="flex flex-col justify-between items-end mr-8 h-full">
                    <div className="mt-4">
                        <TodoList />
                    </div>
                    <div className="mt-6">
                        <img src={Mozzy} alt="Mozzy" className="size-60" onClick={openModal} />
                        <MozzyModal isOpen={modalIsOpen} onClose={closeModal} />
                        <LongSitModal isOpen={longSitModalIsOpen} onClose={closeLongSitModal} />
                    </div>
                </div>
            </div>
        </div>
    );
}
