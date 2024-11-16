import { Component } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { UserService } from 'src/app/services/user.service';
import Swal from 'sweetalert2';

@Component({
  selector: 'app-change-password',
  templateUrl: './change-password.component.html',
  styleUrls: ['./change-password.component.css']
})
export class ChangePasswordComponent {
  public changePasswordForm: FormGroup;
  public errorMessage: string | null = null;

  constructor(
    private fb: FormBuilder,
    private userService: UserService,
    private router: Router
  ) {
    this.changePasswordForm = this.fb.group({
      oldPassword: ['', Validators.required],
      newPassword: ['', [Validators.required, Validators.minLength(6)]],
      confirmPassword: ['', Validators.required]
    });
  }

  onSubmit(): void {
    this.errorMessage = null; 

    if (this.changePasswordForm.invalid) {
      this.errorMessage = 'Please fill all required fields.';
      return;
    }

    const { oldPassword, newPassword, confirmPassword } = this.changePasswordForm.value;

    if (newPassword !== confirmPassword) {
      this.errorMessage = 'New password and confirmation do not match.';
      return;
    }

    this.userService.changePassword(oldPassword, newPassword).subscribe({
      next: () => {
        Swal.fire('Password changed!', 'User Password changed successfully.', 'success');
        this.router.navigate(['/profile']);
      },
      error: (err) => {
        this.errorMessage = 'Error changing password. Please try again.';
        console.error('Error changing password:', err);
      }
    });
  }

  getFieldError(field: string): string | null {
    const control = this.changePasswordForm.get(field);
    if (control && control.invalid && (control.dirty || control.touched)) {
      if (control.errors?.['required']) {
        return `${field} is required`;
      } else if (control.errors?.['minlength']) {
        return `Password must be at least 6 characters`;
      }
    }
    return null;
  }
}
