import { Component } from '@angular/core';
import { AuthService } from 'src/app/services/auth.service';
import { Router } from '@angular/router';
import { AuthModel } from 'src/app/models/auth.model'; 

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css'],
})
export class LoginComponent {
  auth: AuthModel = { email: '', password: '' }; 
  errorMessage: string = '';
  successMessage: string = '';
  submitted: boolean = false;

  constructor(private authService: AuthService, private router: Router) {}

  onSubmit(): void {
    this.submitted = true;

    if (this.isFormInvalid()) {
      this.errorMessage = 'Please fill all required fields.';
      this.successMessage = ''; 
      return;
    }

    this.authService.login(this.auth.email, this.auth.password).subscribe({
      next: (response) => {
        this.authService.setToken(response.token);
        this.successMessage = 'Login successful! Redirecting to Dashboard...';
        this.errorMessage = ''; 

        setTimeout(() => {
          this.router.navigate(['/books']);
        }, 500);
      },
      error: (error) => {
        if (error.status === 401 && error.error.message === 'Invalid email or password.') {
          this.errorMessage = 'Invalid email or password.';
        } else {
          this.errorMessage = 'Login failed. Please try again.';
        }
        this.successMessage = ''; 
        console.error('Login failed:', error); 
      },
    });
  }

  isFormInvalid(): boolean {
    return !this.auth.email || !this.auth.password;
  }
}
