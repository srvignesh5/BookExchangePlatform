import { Component } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { AuthService } from '../../../services/auth.service';

@Component({
  selector: 'app-forget-password',
  templateUrl: './forget-password.component.html',
  styleUrls: ['./forget-password.component.css']
})
export class ForgetPasswordComponent {
  forgetPasswordForm: FormGroup;
  successMessage: string | null = null;
  errorMessage: string | null = null;
  submitted = false;

  constructor(private fb: FormBuilder, private authService: AuthService, private router: Router) {
    this.forgetPasswordForm = this.fb.group({
      email: ['', [Validators.required, Validators.email]],
      newPassword: ['', [Validators.required, Validators.minLength(6)]],
      confirmPassword: ['', [Validators.required]],
    });
  }

  passwordMatch(): boolean {
    return this.forgetPasswordForm.get('newPassword')?.value === this.forgetPasswordForm.get('confirmPassword')?.value;
  }

  onSubmit(): void {
    this.submitted = true; 

    if (this.forgetPasswordForm.valid) {
      if (this.passwordMatch()) { 
        const { email, newPassword } = this.forgetPasswordForm.value;
        this.authService.resetPassword(email, newPassword).subscribe({
          next: () => {
            this.successMessage = 'Password has been reset successfully! Redirecting to login...';
            setTimeout(() => {
              this.router.navigate(['/login']);
            }, 500); 
          },
          error: (err) => {
            if (err.error.message === "Email does not exist.") {
              this.errorMessage = "Email does not exist.";
            } else {
              this.errorMessage = err.error.message; 
            }
          }
        });
      } else {
        this.errorMessage = 'Passwords do not match!';
      }
    } else {
      this.errorMessage = 'Please fill in all required fields correctly.'; 
    }
  }
}
