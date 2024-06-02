export default function LogoutConfirmModal({ onConfirm, onCancel }) {
    return (
        <div className="fixed inset-0 flex items-center justify-center z-50 bg-black bg-opacity-50">
            <div className="bg-white p-7 rounded-xl shadow-lg text-zinc-900">
                <h2 className="text-xl font-bold mb-4">로그아웃 확인</h2>
                <p className="text-lg mb-4">정말 기기에서 로그아웃 하시겠어요?</p>
                <div className="flex justify-center space-x-4 mt-6">
                    <button 
                        className="bg-sky-100 text-lg text-sky-600 font-semibold py-2 px-4 rounded-2xl w-36"
                        onClick={onCancel}
                    >
                        취소
                    </button>
                    <button 
                        className="bg-red-100 text-lg hover:bg-red-700 text-red-600 font-semibold py-2 px-4 rounded-2xl w-36"
                        onClick={onConfirm}
                    >
                        기기 로그아웃
                    </button>
                </div>
            </div>
        </div>
    );
}