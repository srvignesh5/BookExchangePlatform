import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Router } from '@angular/router';
import { Observable, BehaviorSubject } from 'rxjs';
import { RegisterModel } from '../models/register.model';
import { map } from 'rxjs/operators';

interface LoginResponse {
  token: string;
  userId: number;
  role: string;
}

@Injectable({
  providedIn: 'root',
})
export class AuthService {
  private apiUrl = 'https://localhost:5001/api/Auth';
  private usersApiUrl = 'https://localhost:5001/api/Users';
  private fullNameSubject = new BehaviorSubject<string | null>(this.getFullNameFromStorage());
  private userId: number | null = null;
  private role: string | null = null;

  constructor(private http: HttpClient, private router: Router) {}

  login(email: string, password: string): Observable<LoginResponse> {
    return this.http.post<LoginResponse>(`${this.apiUrl}/login`, { email, password }).pipe(
      map((response: LoginResponse) => {
        this.setToken(response.token);
        this.setUserId(response.userId);
        this.setRole(response.role);
        this.userId = response.userId;
        this.role = response.role;
        this.fetchUserFullName();
        return response;
      })
    );
  }

  register(registerData: RegisterModel): Observable<any> {
    return this.http.post(`${this.apiUrl}/register`, registerData);
  }

  resetPassword(email: string, newPassword: any): Observable<any> {
    return this.http.post(`${this.apiUrl}/reset-password`, { email, newPassword });
  }

  setToken(token: string): void {
    localStorage.setItem('token', token);
  }

  getToken(): string | null {
    return localStorage.getItem('token');
  }

  isLoggedIn(): boolean {
    return this.getToken() !== null;
  }

  setUserId(userId: any): void {
    localStorage.setItem('userId', userId);
  }

  getUserId(): string | null {
    return localStorage.getItem('userId');
  }

  setRole(role: string): void {
    localStorage.setItem('role', role);
  }

  getRole(): string | null {
    return localStorage.getItem('role');
  }

  isUserInRole(role: string): boolean {
    return this.getRole() === role;
  }

  isAdmin(): boolean {
    return this.isUserInRole('Admin');
  }

  private setFullNameInStorage(fullName: string): void {
    localStorage.setItem('fullName', fullName);
  }

  private getFullNameFromStorage(): string | null {
    return localStorage.getItem('fullName');
  }

  getUserFullName(): Observable<string | null> {
    return this.fullNameSubject.asObservable();
  }

  fetchUserFullName(): void {
    if (this.userId) {
      this.http.get<any>(`${this.usersApiUrl}/${this.userId}`, this.getHeaders())
        .subscribe(user => {
          if (user && user.fullName) {
            this.setFullNameInStorage(user.fullName); 
            this.fullNameSubject.next(user.fullName);
          }
        }, error => {
          console.error('Error fetching user full name:', error);
          this.fullNameSubject.next(null);
        });
    }
  }

  logout(): void {
    localStorage.removeItem('token');
    localStorage.removeItem('fullName');
    localStorage.removeItem('role');
    this.fullNameSubject.next(null);
    this.userId = null;
    this.role = null;
    this.router.navigate(['/login']);
  }
  
  private getHeaders() {
    const token = this.getToken();
    return {
      headers: new HttpHeaders({
        'Content-Type': 'application/json',
        Authorization: `Bearer ${token}`,
      }),
    };
  }
}
