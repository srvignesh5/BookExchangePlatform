import { Injectable } from '@angular/core';
import { Subject, Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class WebSocketService {
  private socket: WebSocket | null = null;
  private messageSubject = new Subject<any>();

  public messages: Observable<any> = this.messageSubject.asObservable();

  public connect(wsUrl: string): void {
    this.socket = new WebSocket(wsUrl);

    this.socket.onmessage = (event) => {
      this.messageSubject.next(JSON.parse(event.data));
    };

    this.socket.onerror = (event) => {
      console.error('WebSocket error:', event);
    };

    this.socket.onclose = (event) => {
      console.warn('WebSocket closed:', event);
    };
  }

  public sendMessage(message: any): void {
    if (this.socket && this.socket.readyState === WebSocket.OPEN) {
      this.socket.send(JSON.stringify(message));
    } else {
      console.error('WebSocket is not open. Cannot send message.');
    }
  }

  public disconnect(): void {
    if (this.socket) {
      this.socket.close();
    }
  }
}
