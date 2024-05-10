import React, { useState, useEffect } from 'react';
const OPEN_WEATHER_API_KEY = import.meta.env.VITE_OPEN_WEATHER_API;
const CITY_NAME = 'Busan';

export default function HomeClockComponent() {
    const [currentTime, setCurrentTime] = useState(new Date());
    const [weatherIcon, setWeatherIcon] = useState('');

    useEffect(() => {
        const timer = setInterval(() => {
            setCurrentTime(new Date());
        }, 1000);

        // OpenWeatherMap API
        const fetchWeatherIcon = async () => {
            try {
                const response = await fetch(`https://api.openweathermap.org/data/2.5/weather?q=${CITY_NAME}&appid=${OPEN_WEATHER_API_KEY}`);
                const data = await response.json();
                const iconCode = data.weather[0].icon; // 날씨 아이콘 코드 추출
                setWeatherIcon(`https://openweathermap.org/img/wn/${iconCode}@2x.png`);
            } catch (error) {
                console.error("Weather data fetch error:", error);
            }
        };

        fetchWeatherIcon();

        return () => {
            clearInterval(timer);
        };
    }, []);

    const formattedTime = currentTime.toLocaleTimeString('ko-KR', {
        hour: '2-digit',
        minute: '2-digit',
        hour12: false
    });

    const formattedDate = currentTime.toLocaleDateString('ko-KR', {
        month: 'long',
        day: 'numeric',
        weekday: 'long',
    });

    return (
        <div className="text-white rounded-lg p-4 text-center font-noto-sans mt-2">
            <div className="flex flex-row text-date opacity-70 ml-1">
                <span className="ml-3">{formattedDate}</span> {weatherIcon? <img src={weatherIcon} alt="Weather Icon" className="ml-1 size-8"/> : '☀'}
            </div>
            <div className="text-clock leading-none font-semibold">
                {formattedTime}
            </div>
        </div>
    );
}
