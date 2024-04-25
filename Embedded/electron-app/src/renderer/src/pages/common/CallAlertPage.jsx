import garden from '../../assets/call_garden.svg'
import mozzy from '../../assets/call_mozzy.svg';
export default function CallAlert() {
  return (
    <div className="flex flex-row justify-between h-dvh w-full bg-teal-600 p-12 text-center text-white">
      <div className="flex-1 flex items-start justify-start">
        <div className="bg-white rounded-full flex items-center px-4 py-2">
          <img
            className="size-12 rounded-full mr-3"
            src={garden}
            alt="profile image"
          />
          <span className="text-xl text-black">이정원(교육프로)</span>
        </div>
      </div>
      <div className="flex-1 flex flex-col">
        <div className="flex-1 flex items-center justify-center">
          <div></div>
        </div>
        <div className="flex-1 flex items-center justify-center text-5xl font-bold">호출</div>
        <div className="flex-1 flex items-center justify-center">
          <div className="bg-gray-500 bg-opacity-50 py-2 px-4 rounded-full inline-block">
            <span>지수님 필드트립 관련 잠깐 로비로 나와주실 수 있으실까요?</span>
          </div>
        </div>
      </div>
      <div className="flex-1 flex flex-col items-center justify-end">
        <img className="size-72" src={mozzy} alt="mozzy icon" />
      </div>
    </div>
  )
}
