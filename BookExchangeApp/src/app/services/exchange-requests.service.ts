import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';
import { ExchangeRequest } from '../models/exchange-request.model';

@Injectable({
  providedIn: 'root'
})
export class ExchangeRequestsService {
  private apiUrl = 'https://localhost:5001/api/ExchangeRequests';

  constructor(private http: HttpClient) {}

  getAllExchangeRequests(): Observable<ExchangeRequest[]> {
    return this.http.get<ExchangeRequest[]>(this.apiUrl, this.getHeaders());
  }

  getMyExchangeRequests(): Observable<ExchangeRequest[]> {
    return this.http.get<ExchangeRequest[]>(`${this.apiUrl}/myrequests`, this.getHeaders());
  }

  checkExistingExchangeRequestByBook(bookId: number): Observable<ExchangeRequest[]> {
    return this.http.get<ExchangeRequest[]>(`${this.apiUrl}/check/${bookId}`, this.getHeaders());
  }

  getExchangeRequestById(id: number): Observable<ExchangeRequest> {
    return this.http.get<ExchangeRequest>(`${this.apiUrl}/${id}`, this.getHeaders());
  }

  createExchangeRequest(exchangeRequest: ExchangeRequest): Observable<any> {
    return this.http.post(this.apiUrl, exchangeRequest, this.getHeaders());
  }

  updateExchangeRequest(id: number, exchangeRequest: ExchangeRequest): Observable<any> {
    return this.http.put(`${this.apiUrl}/${id}`, exchangeRequest, this.getHeaders());
  }

  deleteExchangeRequest(id: number): Observable<any> {
    return this.http.delete(`${this.apiUrl}/${id}`, this.getHeaders());
  }

  private getHeaders(): { headers: HttpHeaders } {
    const token = localStorage.getItem('token');
    return {
      headers: new HttpHeaders({
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json'
      })
    };
  }
}
