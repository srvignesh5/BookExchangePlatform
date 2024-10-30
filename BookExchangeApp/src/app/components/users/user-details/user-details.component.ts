import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { UserService } from 'src/app/services/user.service';
import { User } from 'src/app/models/user.model';

@Component({
  selector: 'app-user-details',
  templateUrl: './user-details.component.html',
  styleUrls: ['./user-details.component.css']
})
export class UserDetailsComponent implements OnInit {
  user: User | null = null;
  errorMessage: string = ''; 

  constructor(private route: ActivatedRoute, private userService: UserService) {}
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
        this.errorMessage = 'User details could not be fetched.';
        console.error(err);
      }
    });
  }
}
