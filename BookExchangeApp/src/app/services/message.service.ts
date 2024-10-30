import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Message } from '../models/message.model';

@Injectable({
  providedIn: 'root'
})
export class MessageService {
  private baseUrl = 'https://localhost:5001/api/Messages';

  constructor(private http: HttpClient) {}

  getAllMessages(): Observable<Message[]> {
    return this.http.get<Message[]>(this.baseUrl,this.getHeaders());
  }

  getMessagesByExchangeRequestId(exchangeRequestId: number): Observable<Message[]> {
    return this.http.get<Message[]>(`${this.baseUrl}/exchange/${exchangeRequestId}`,this.getHeaders());
  }

  getMessageById(messageId: number): Observable<Message> {
    return this.http.get<Message>(`${this.baseUrl}/${messageId}`,this.getHeaders());
  }

  createMessage(message: Message): Observable<Message> {
    return this.http.post<Message>(this.baseUrl, message,this.getHeaders());
  }

  updateMessage(message: Message): Observable<Message> {
    return this.http.put<Message>(`${this.baseUrl}/${message.messageId}`, message,this.getHeaders());
  }

  deleteMessage(messageId: number): Observable<void> {
    return this.http.delete<void>(`${this.baseUrl}/${messageId}`,this.getHeaders());
  }

  private getHeaders() {
    const token = localStorage.getItem('token');
    return {
      headers: new HttpHeaders({
        'Content-Type': 'application/json',
        Authorization: `Bearer ${token}`,
      }),
    };
  }

}
