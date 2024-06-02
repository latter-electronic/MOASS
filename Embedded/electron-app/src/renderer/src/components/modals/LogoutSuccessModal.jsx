export default function LogoutSuccessModal({ onClose }) {
    return (
      <div className="fixed inset-0 flex items-center justify-center z-50 bg-black bg-opacity-50">
        <div className="bg-white p-7 rounded-lg shadow-lg text-zinc-900">
          <h2 className="text-xl font-bold mb-4">로그아웃 성공</h2>
          <p className="text-lg mb-4">로그아웃이 성공적으로 완료되었습니다.</p>
          <div className="flex justify-center mt-6">
            <button
              className="bg-green-100 text-lg hover:bg-green-700 text-green-600 font-semibold py-2 px-4 rounded-2xl w-36"
              onClick={onClose}
            >
              닫기
            </button>
          </div>
        </div>
      </div>
    );
  }