import BoardComponent from './BoardComponent.jsx'
import headerIcon from '../../assets/images/board/board-header-icon.svg';

export default function BoardHistoryPage() {
    return (
        <div className="flex flex-col p-6 w-full">
            <div className="flex justify-between items-center mb-4">
                <div className="flex items-center gap-2">
                    <h1 className="text-4xl font-medium">이음보드 기록</h1>
                    <img src={headerIcon} alt="Board Header Icon" className="w-8 h-8 mt-1" />
                </div>
            </div>

            <div className="flex flex-row overflow-x-auto py-2 gap-4 mt-10">
                <BoardComponent />
                <BoardComponent />
                <BoardComponent />
            </div>
        </div>
    );
}
