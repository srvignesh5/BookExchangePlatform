import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { User } from 'src/app/models/user.model';
import { UserService } from 'src/app/services/user.service';

@Component({
  selector: 'app-user-edit',
  templateUrl: './user-edit.component.html',
  styleUrls: ['./user-edit.component.css']
})
export class UserEditComponent implements OnInit {
  public user: User;
  public errorMessage: string | null = null;

  constructor(
    private userService: UserService,
    private route: ActivatedRoute,
    public router: Router
  ) {
    this.user = {} as User;
  }

  ngOnInit(): void {
    const userId = this.route.snapshot.paramMap.get('id');
    if (userId) {
      this.getUserDetails(+userId);
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
      this.userService.updateUser(+this.user.userId, this.user).subscribe({
        next: () => {
          alert('User updated successfully');
          this.router.navigate(['/users']);
        },
        error: (err) => {
          this.errorMessage = 'Error updating user.';
          console.error('Error updating user:', err);
        }
      });
    }
  }
}
