import { EventSourcePolyfill } from 'event-source-polyfill';

class EventService {
    constructor(url, headers) {
        this.url = url;
        this.headers = headers;
        this.initEventSource();
    }

    initEventSource() {
        console.log('Initializing Event Source...');
        this.eventSource = new EventSourcePolyfill(this.url, {
            headers: this.headers,
        });

        this.eventSource.onopen = () => {
            console.log('Connection to SSE opened');
        };

        this.eventSource.onerror = (error) => {
            console.error('EventSource error:', error);
            this.eventSource.close();
        };
    }

    startListening(onMessage) {
        console.log('Listening for messages...');
        this.eventSource.onmessage = (event) => {
            const data = event.data;
            onMessage(data); // 파싱하지 않고 그대로 전달
        };
    }

    stopListening() {
        this.eventSource.close();
    }
}

export default EventService;
