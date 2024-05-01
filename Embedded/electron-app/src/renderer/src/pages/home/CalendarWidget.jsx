import Calendar from "../../assets/Calendar.png"

export default function CalendarWidget() {
    return(
        <>
            <div className="flex items-center justify-center align-middle mt-10">
            <img src={ Calendar } alt="캘린더" className="rounded w-36"/>
        </div>
        </>
    );
}