import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';
import { TransactionHistory } from '../models/transaction-history.model';

@Injectable({
  providedIn: 'root'
})
export class TransactionHistoryService {
  private apiUrl = 'https://localhost:5001/api/TransactionHistories';

  constructor(private http: HttpClient) {}

  getAllTransactionHistories(): Observable<TransactionHistory[]> {
    return this.http.get<TransactionHistory[]>(this.apiUrl, this.getHeaders());
  }

  getTransactionHistoriesByExchangeRequestId(exchangeRequestId: number): Observable<TransactionHistory[]> {
    return this.http.get<TransactionHistory[]>(`${this.apiUrl}/exchange/${exchangeRequestId}`, this.getHeaders());
  }

  getTransactionHistoryById(transactionId: number): Observable<TransactionHistory> {
    return this.http.get<TransactionHistory>(`${this.apiUrl}/${transactionId}`, this.getHeaders());
  }

  createTransactionHistory(transactionHistory: TransactionHistory): Observable<TransactionHistory> {
    return this.http.post<TransactionHistory>(this.apiUrl, transactionHistory, this.getHeaders());
  }

  updateTransactionHistory(transactionId: number, transactionHistory: TransactionHistory): Observable<TransactionHistory> {
    return this.http.put<TransactionHistory>(`${this.apiUrl}/${transactionId}`, transactionHistory, this.getHeaders());
  }

  deleteTransactionHistory(transactionId: number): Observable<void> {
    return this.http.delete<void>(`${this.apiUrl}/${transactionId}`, this.getHeaders());
  }

  private getHeaders() {
    const token = localStorage.getItem('token');
    return {
      headers: new HttpHeaders({
        'Content-Type': 'application/json',
        Authorization: `Bearer ${token}`
      })
    };
  }
}
