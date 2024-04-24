import Clock from './ClockComponent.jsx'
import Calendar from './CalendarWidget.jsx'
import TodoList from './TodoListComponent.jsx'
import Schedule from './ScheduleCard.jsx'

export default function HomePage() {
    return(
        <div>
            <div className="container mx-auto p-4">
                <Clock />
                <div className="grid grid-cols-3 gap-4">
                    <div>
                        <Calendar />
                    </div>
                    <div>
                        <Schedule />
                    </div>
                    <div>
                        <TodoList />
                    </div>
                </div>
            </div>
        </div>
    );
}
