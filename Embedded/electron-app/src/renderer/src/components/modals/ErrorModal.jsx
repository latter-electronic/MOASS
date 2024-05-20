function ErrorModal({ message, onConfirm }) {
    return (
        <div className="absolute top-0 left-0 w-full h-full flex items-center justify-center bg-gray-800 bg-opacity-50">
            <div className="bg-white p-4 rounded shadow-lg">
                <p>{message}</p>
                <button onClick={onConfirm} className="mt-4 bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">
                    확인
                </button>
            </div>
        </div>
    );
}