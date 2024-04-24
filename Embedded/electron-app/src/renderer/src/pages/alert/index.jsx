import { useNavigate } from 'react-router-dom';

export default function alert() {
    const navigate = useNavigate();
    const callAlertFunction = () => {
        navigate(`/callalert`);
    };

    return (
        <>
            <div className="text-4xl font-extrabold">알림 모아쓰 탭</div>
            <button onClick={() => callAlertFunction()}>button</button>
        </>
    );
}