import { Component, OnInit, TemplateRef } from '@angular/core';
import { BsModalService, BsModalRef } from 'ngx-bootstrap/modal';
import Swal from 'sweetalert2';
import { User } from 'src/app/models/user.model';
import { UserService } from 'src/app/services/user.service';
import { AuthService } from 'src/app/services/auth.service';

@Component({
  selector: 'app-user-list',
  templateUrl: './user-list.component.html',
  styleUrls: ['./user-list.component.css']
})
export class UserListComponent implements OnInit {
  public users: User[] = [];
  public selectedUser: User = { userId: 0, email: '', fullName: '', password: '' };
  public currentPage: number = 1;
  public itemsPerPage: number = 10;
  public searchTerm: string = '';
  public errorMessage: string = '';
  public modalRef?: BsModalRef;

  constructor(
    private userService: UserService,
    private authService: AuthService,
    private modalService: BsModalService
  ) {}

  ngOnInit(): void {
    this.loadUsers();
  }
  
  loadUsers(): void {
    this.userService.getUsers().subscribe({
      next: (data) => {
        this.users = data;
      },
      error: (err) => {
        console.error('Error fetching users:', err);
        this.errorMessage = 'Failed to load users. Please try again later.';
      }
    });
  }

  searchUsers(): void {
  }

  viewUser(userId: number, template: TemplateRef<any>): void {
    this.selectedUser = this.users.find(user => user.userId === userId) || { userId: 0, email: '', fullName: '', password: '' }; // Handle not found
    this.modalRef = this.modalService.show(template);
  }

  openUpdateModal(template: TemplateRef<any>, user: User): void {
    this.selectedUser = { ...user }; 
    this.modalRef = this.modalService.show(template);
  }

  updateUser(): void {
    if (this.selectedUser.userId) {
      this.userService.updateUser(this.selectedUser.userId, this.selectedUser).subscribe({
        next: () => {
          Swal.fire('Updated!', 'The user has been updated.', 'success');
          this.loadUsers();
          this.modalRef?.hide();
        },
        error: (err) => {
          console.error('Error updating user:', err);
          Swal.fire('Error!', 'There was an error updating the user.', 'error');
        }
      });
    }
  }

  
  confirmDelete(userId: number): void {
    Swal.fire({
      title: 'Are you sure?',
      text: 'Do you really want to delete this user?',
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#3085d6',
      cancelButtonColor: '#d33',
      confirmButtonText: 'Yes, delete it!'
    }).then((result) => {
      if (result.isConfirmed) {
        this.userService.deleteUser(userId).subscribe({
          next: () => {
            Swal.fire('Deleted!', 'The user has been deleted.', 'success');
            this.loadUsers();
          },
          error: (err) => {
            console.error('Error deleting user:', err);
            Swal.fire('Error!', 'There was an error deleting the user.', 'error');
          }
        });
      }
    });
  }

  get paginatedUsers(): User[] {
    const startIndex = (this.currentPage - 1) * this.itemsPerPage;
    return this.filteredUsers.slice(startIndex, startIndex + this.itemsPerPage);
  }

  get filteredUsers(): User[] {
    return this.users.filter(user =>
      (user.fullName?.toLowerCase() || '').includes(this.searchTerm.toLowerCase()) ||
      (user.email?.toLowerCase() || '').includes(this.searchTerm.toLowerCase())
    ).slice((this.currentPage - 1) * this.itemsPerPage, this.currentPage * this.itemsPerPage); 
  }

  sortData(key: string): void {
  }
}
