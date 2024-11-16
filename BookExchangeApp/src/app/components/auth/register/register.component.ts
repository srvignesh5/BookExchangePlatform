import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { AuthService } from '../../../services/auth.service';
import { RegisterModel } from '../../../models/register.model';

@Component({
  selector: 'app-register',
  templateUrl: './register.component.html',
  styleUrls: ['./register.component.css']
})
export class RegisterComponent {
  auth: RegisterModel = {
    role: 'User',
    fullName: '',
    email: '',
    password: '',
    preferences: '',
    address: '',
    bio: '',
    favoriteGenres: ''
  };
  confirmPassword: string = '';
  submitted: boolean = false;
  successMessage: string = '';
  errorMessage: string = '';
  favoriteGenresOptions: string[] = [
    'Fiction', 'Non-Fiction', 'Mystery', 'Science Fiction', 'Fantasy', 'Biography',
    'Historical Fiction', 'Romance', 'Thriller', 'Self-Help', 'Graphic Novels', 
    'Adventure', 'Poetry', 'Horror', 'Science & Technology', 'Education', 'Cookbooks',
    'Religion & Spirituality'
  ];

  constructor(private authService: AuthService, private router: Router) {}

  onSubmit(): void {
    this.submitted = true;
    this.auth.preferences = this.auth.favoriteGenres;

    if (this.isFormInvalid()) {
      this.errorMessage = 'Please fill all required fields.';
      this.successMessage = '';
      return;
    }

    if (this.passwordMismatch()) {
      this.errorMessage = 'Passwords do not match.';
      this.successMessage = '';
      return;
    }

    this.authService.register(this.auth).subscribe({
      next: (response) => {
        if (response && response.message === 'User created successfully.') {
          this.successMessage = 'Registration successful! Redirecting to login...';
          this.errorMessage = '';
          setTimeout(() => {
            this.router.navigate(['/login']);
          }, 100);
        }
      },
      error: (error) => {
        if (error.status === 400 && error.error === 'User already exists. Please use a different email address.') {
          this.errorMessage = 'User already exists. Please use a different email address.';
        } else {
          this.errorMessage = 'Registration failed. Please try again.';
        }
        this.successMessage = '';
      }
    });
  }

  isFormInvalid(): boolean {
    return !this.auth.fullName || !this.auth.email || !this.auth.password || !this.auth.favoriteGenres;
  }

  passwordMismatch(): boolean {
    return this.auth.password !== this.confirmPassword;
  }
}
