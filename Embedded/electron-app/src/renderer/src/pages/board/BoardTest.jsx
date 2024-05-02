export default function BoardTest() {
    // 뒤로 가기 버튼 핸들러
    function goBack() {
        window.history.back();
    }

    return (
        <div className="w-screen h-screen bg-white">
            <iframe
                src="http://k10e203.p.ssafy.io:5001/boards/J-VR-Dvm0K7Fmr7pG9IHauWLXDG-5EImxUqbI5EUV3Y-"
                title="Embedded Board"
                className="w-full h-full"
                frameBorder="0"
                allowFullScreen
            ></iframe>
            <button 
                onClick={goBack} 
                className="absolute top-5 ml-20 z-10 text-white bg-blue-500 hover:bg-blue-700 font-medium py-2 px-4 rounded"
            >
                뒤로 가기
            </button>
        </div>
    );
}
