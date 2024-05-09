import { PixelEditor } from "./PixelEditor";
import { useEffect, useRef, useState } from 'react';
import { Client } from '@stomp/stompjs';
import './App.css';
import { PixelState } from "./LWWMap";

function App() {
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const paletteRef = useRef<HTMLInputElement>(null);
  const [stompClient, setStompClient] = useState<Client | null>(null);

  useEffect(() => {
    const canvas = canvasRef.current;
    const palette = paletteRef.current;

    if (!canvas || !palette) {
        return;
    }

    const artBoard = { w: 128, h: 128 };
    const editor = new PixelEditor(canvas, artBoard);

    const client = new Client({
      brokerURL: 'wss://k10e203.p.ssafy.io:9090/ws',
      debug: (str: string) => {
        console.log(str)
      },
      reconnectDelay: 5000,
      heartbeatIncoming: 4000,
      heartbeatOutgoing: 4000,
    });

    setStompClient(client);
    client.activate();

    client.onConnect = () => {
      client.subscribe(`/topic/board/draw`, (state) => {
        editor.receive(JSON.parse(state.body) as PixelState);
      })
    }

    editor.onchange = (state) => {
      client.publish({
        destination: `/app/draw`,
        body: JSON.stringify(state)
      })
    };

    palette.oninput = () => (editor.color = palette.value.substring(1));

    // client.subscribe('/topic/clear', () => {
    //   editor.clear();
    // });

    return () => {
      editor.onchange = () => null;
      // client.deactivate();
    };
  }, []);

  return (
      <div className="leading-normal">
          <div className="flex pt-12 pb-8">
              <div>
                  <canvas className="bg-white w-64 h-64 border-2 cursor-crosshair touch-none" ref={canvasRef} />
              </div>
              <div className="pl-2 flex flex-col justify-end">
                  <input className="color mb-2 w-6 h-6" ref={paletteRef} type="color" defaultValue="#000000" />
              </div>
          </div>
      </div>
  );
}

export default App;
