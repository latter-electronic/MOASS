import { EventSourcePolyfill } from 'event-source-polyfill';

class EventService {
    constructor(url, headers) {
        this.url = url;
        this.headers = headers;
        this.initEventSource();
    }

    initEventSource() {
        console.log('3.initEventSource 호출!')
        this.eventSource = new EventSourcePolyfill(this.url, {
            headers: this.headers
        });

        this.eventSource.onopen = () => {
            console.log('4. Connection to SSE opened');
        };

        this.eventSource.onerror = (error) => {
            console.error('4. EventSource failed:', error);
            this.eventSource.close();
        };
    }

    startListening(onMessage) {
        console.log('스타트리스닝중')
        this.eventSource.onmessage = (event) => {
            console.log('온메세지중')
            const data = event.data;
            onMessage(data);
        };
    }

    stopListening() {
        this.eventSource.close();
    }
}

export default EventService;