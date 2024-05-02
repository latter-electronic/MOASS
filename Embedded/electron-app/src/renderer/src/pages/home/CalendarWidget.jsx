import Calendar from 'react-calendar'
import './Calendar.css';
import moment from 'moment';


export default function CalendarWidget() {
    return(
        <div>
           <Calendar
                locale="ko"
                next2Label={null}
                prev2Label={null}
                formatDay={(locale, date) => moment(date).format('D')}
                showNeighboringMonth={false}
                calendarType="gregory"
            />
            
        </div>
    );
}