export default function BoardTest() {
    // 뒤로 가기 버튼 핸들러
    function goBack() {
        window.history.back();
    }

    return (
        <div className="w-screen h-screen">
            <iframe
                src="https://wbo.ophir.dev/boards/moass"
                title="Embedded Board"
                className="w-full h-full bg-white"
                frameBorder="0"
                allowFullScreen
            ></iframe>
            <button 
                onClick={goBack} 
                className="absolute top-5 left-5 z-10 text-white bg-blue-500 hover:bg-blue-700 font-medium py-2 px-4 rounded"
            >
                뒤로 가기
            </button>
        </div>
    );
}