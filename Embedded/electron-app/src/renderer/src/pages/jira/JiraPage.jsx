import IssueCard from './JiraIssueCard.jsx';

export default function JiraPage() {
    return (
        <div className=" mx-auto p-6 h-screen">
            <div className="text-white font-bold text-2xl mb-5">S10P31E203 보드</div>
            <div className="grid grid-cols-3 gap-5 h-full w-[88vw] ml-3">

                {/* 해야 할 일 */}
                <div className="flex flex-col">
                    <div className="bg-white/10 p-3 rounded-lg flex-1">
                        <h3 className="text-white/70 text-lg ml-1 font-light">해야 할 일</h3>
                        <div className="mt-2">
                            <IssueCard />
                            <IssueCard />
                            <IssueCard />
                        </div>
                    </div>
                </div>

                {/* 진행 중 */}
                <div className="flex flex-col">
                    <div className="bg-white/10 p-3 rounded-lg flex-1">
                        <h3 className="text-white/70 text-lg ml-1 font-light">진행 중</h3>
                        {/* Place for current tasks */}
                    </div>
                </div>

                {/* 완료 */}
                <div className="flex flex-col">
                    <div className="bg-white/10 p-3 rounded-lg flex-1">
                        <h3 className="text-white/70 text-lg ml-1 font-light">완료</h3>
                        {/* Place for completed tasks */}
                    </div>
                </div>

            </div>
        </div>
    );
}
