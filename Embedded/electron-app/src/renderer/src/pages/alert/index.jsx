import { useNavigate } from 'react-router-dom';

export default function Alert() {
    const navigate = useNavigate();

    const callAlertFunction = () => {
        navigate(`/callalert`);
    };

    const callNamePlateFunction = () => {
        navigate(`/nameplate`);
    };

    return (
        <>
            <div className="text-4xl font-extrabold mb-8">알림 모아쓰 탭</div>
            <button 
                onClick={() => callAlertFunction()}
                className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-lg shadow-md transition duration-300 ease-in-out mb-4"
            >
                개발용 호출
            </button>
            <button 
                onClick={() => callNamePlateFunction()}
                className="bg-green-500 hover:bg-green-700 text-white font-bold py-2 px-4 rounded-lg shadow-md transition duration-300 ease-in-out"
            >
                개발용 명패
            </button>
        </>
    );
}
