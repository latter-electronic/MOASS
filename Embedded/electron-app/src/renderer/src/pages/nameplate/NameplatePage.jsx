import { useNavigate } from 'react-router-dom';

export default function NameplatePage() {
    const navigate = useNavigate();

    const callAlertFunction = () => {
        navigate(`/alert`);
    };

    return(
        <div>
            <button 
                onClick={() => callAlertFunction()}
                className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-lg shadow-md transition duration-300 ease-in-out mb-4"
            >
                돌아가기
            </button>
        </div>
    );
}