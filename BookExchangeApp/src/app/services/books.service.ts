import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Book } from '../models/book.model';

@Injectable({
  providedIn: 'root'
})
export class BooksService {
  private apiUrl = 'https://localhost:5001/api/Books';

  constructor(private http: HttpClient) {}

  getUserId(): any | null {
    return localStorage.getItem('userId');
  }

  getAllBooks(): Observable<Book[]> {
    return this.http.get<Book[]>(this.apiUrl,this.getHeaders());
  }

  getMyBooks(): Observable<Book[]> {
    return this.http.get<Book[]>(`${this.apiUrl}/mybooks`, this.getHeaders());
  }

  getBookById(id: number): Observable<Book> {
    return this.http.get<Book>(`${this.apiUrl}/${id}`, this.getHeaders());
  }

  createBook(book: Book): Observable<any> {
    book.userId = this.getUserId();
    return this.http.post(this.apiUrl, book, this.getHeaders());
  }

  updateBook(bookId: number, book: Book): Observable<any> {
    return this.http.put(`${this.apiUrl}/${bookId}`, book, this.getHeaders());
  }

  deleteBook(bookId: number): Observable<any> {
    return this.http.delete(`${this.apiUrl}/${bookId}`, this.getHeaders());
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
