import { EventSourcePolyfill } from 'event-source-polyfill';

class EventService {
    constructor(url, headers) {
        this.eventSource = new EventSourcePolyfill(url, {
            headers: headers
        });
    }

    startListening(onMessage) {
        this.eventSource.onmessage = (event) => {
            const data = JSON.parse(event.data);
            onMessage(data);
        };

        this.eventSource.onerror = (error) => {
            console.error("EventSource failed:", error);
        };
    }

    stopListening() {
        this.eventSource.close();
    }
}

export default EventService;
