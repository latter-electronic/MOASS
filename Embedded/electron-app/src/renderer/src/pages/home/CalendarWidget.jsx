import Calendar from "../../assets/Calendar.png"

export default function CalendarWidget() {
    return(
        <>
            <div class="flex items-center justify-center">
            <img src={ Calendar } alt="캘린더" className="w-56 rounded ml-6 mb-6"/>
        </div>
        </>
    );
}