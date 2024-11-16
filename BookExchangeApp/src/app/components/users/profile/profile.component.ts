import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { User } from 'src/app/models/user.model';
import { UserService } from 'src/app/services/user.service';
import Swal from 'sweetalert2';

@Component({
  selector: 'app-profile',
  templateUrl: './profile.component.html',
  styleUrls: ['./profile.component.css']
})
export class ProfileComponent implements OnInit {
  public user: User;
  public errorMessage: string | null = null;
  public isEditMode: boolean = false;

  constructor(
    private userService: UserService,
    private router: Router
  ) {
    this.user = {} as User;
  }

  ngOnInit(): void {
    this.loadUserIdAndFetchDetails(); 
  }

  loadUserIdAndFetchDetails(): void {
    const userId = this.userService.getUserId();
    if (userId) {
      this.getUserDetails(+userId);
    } else {
      this.errorMessage = 'User ID not found. Please log in again.';
      this.router.navigate(['/login']);
    }
  }

  getUserDetails(userId: number): void {
    this.userService.getUserById(userId).subscribe({
      next: (data) => {
        this.user = data;
      },
      error: (err) => {
        this.errorMessage = 'Error fetching user details.';
        console.error('Error fetching user details:', err);
      }
    });
  }
  
  updateUser(): void {
    if (this.user && this.user.userId) {
      this.userService.updateUser(this.user.userId, this.user).subscribe({
        next: () => {
          Swal.fire('Updated!', 'User details have been updated.', 'success');
          this.isEditMode = false;
          this.getUserDetails(this.user.userId);
        },
        error: (err) => {
          this.errorMessage = 'Error updating user.';
          Swal.fire('Error!', 'There was an error updating the user.', 'error');
          console.error('Error updating user:', err);
        }
      });
    }
  }

  toggleEditMode(): void {
    this.isEditMode = !this.isEditMode;
  }
}
