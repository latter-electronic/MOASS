import IssueCard from './JiraIssueCard.jsx';

export default function JiraPage() {
    return (
        <div className=" mx-auto p-4 h-screen w-90vh">
            <div className="text-white font-bold text-2xl mb-5">S10P31E203 보드</div>
            <div className="grid grid-cols-3 gap-8 h-full">
            
            
                {/* Todo Column */}
                <div>
                    <div className="bg-gray-700 p-3">
                        <h3 className="text-white text-lg">Todo</h3>
                        <div className="mt-2">
                            {/* Place the IssueCard Component here */}
                            <IssueCard />
                        </div>
                    </div>
                </div>

                {/* Now Column */}
                <div className="flex-1">
                    <div className="bg-gray-700 p-3">
                        <h3 className="text-white text-lg">Now</h3>
                        {/* Place for current tasks */}
                    </div>
                </div>

                {/* Done Column */}
                <div className="flex-1">
                    <div className="bg-gray-700 p-3">
                        <h3 className="text-white text-lg">Done</h3>
                        {/* Place for completed tasks */}
                    </div>
                </div>
            
            </div>
        </div>
    );
}
