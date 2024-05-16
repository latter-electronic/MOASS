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
            withCredentials: true,
        });

        this.eventSource.onopen = () => {
            console.log('Connection to SSE opened');
        };

        this.eventSource.onmessage = (event) => {
            this.onMessage && this.onMessage(event);
        };

        this.eventSource.onerror = (error) => {
            console.error('EventSource error:', error);
            if (error.eventPhase === EventSource.CLOSED) {
                this.reconnect();
            }
        };

        // Optional: Heartbeat to keep the connection alive
        this.heartbeatInterval = setInterval(() => {
            if (this.eventSource.readyState === EventSourcePolyfill.CLOSED) {
                this.reconnect();
            }
        }, 45000); // Check every 45 seconds
    }

    startListening(onMessage) {
        console.log('Listening for messages...');
        this.onMessage = onMessage;
    }

    stopListening() {
        clearInterval(this.heartbeatInterval);
        this.eventSource.close();
    }

    reconnect() {
        this.stopListening();
        setTimeout(() => {
            console.log('Reconnecting to SSE...');
            this.initEventSource();
        }, 1000); // 1초 후에 재연결 시도
    }
}

export default EventService;
