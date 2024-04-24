import { useNavigate } from 'react-router-dom';
export default function Home() {
    const navigate = useNavigate();
    const callAlertFunction = () => {
        navigate(`/callalert`);
    };

    return(
        <div>
            <div className="text-4xl font-extrabold">메인탭입니당</div>
            <button onClick={() => callAlertFunction()}>button</button>
        </div>
    );
    }