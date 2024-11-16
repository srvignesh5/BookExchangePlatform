import { Component, OnInit, TemplateRef } from '@angular/core';
import { Router } from '@angular/router';
import { Book } from 'src/app/models/book.model';
import { BooksService } from 'src/app/services/books.service';
import Swal from 'sweetalert2';
import { BsModalService, BsModalRef } from 'ngx-bootstrap/modal';
import { AuthService } from 'src/app/services/auth.service';

@Component({
  selector: 'app-my-books',
  templateUrl: './my-books.component.html',
  styleUrls: ['./my-books.component.css']
})
export class MyBooksComponent implements OnInit {
  public myBooks: Book[] = [];
  public searchQuery: string = '';
  public page: number = 1;
  public errorMessage: string = '';
  public sortDirection: boolean = true;
  public sortKey: string = '';
  public isAdmin: boolean = false;
  public modalRef?: BsModalRef;
  public selectedBook: Book = {
    bookId: 0,
    userId: '',
    title: '',
    author: '',
    genre: '',
    condition: '',
    availabilityStatus: false
  }; 
  public newBook: Book = {
    bookId: 0,
    userId: '',
    title: '',
    author: '',
    genre: '',
    condition: '',
    availabilityStatus: true 
  }; 

  GenresOptions: string[] = [
    'Fiction', 'Non-Fiction', 'Mystery', 'Science Fiction', 'Fantasy', 'Biography',
    'Historical Fiction', 'Romance', 'Thriller', 'Self-Help', 'Graphic Novels', 
    'Adventure', 'Poetry', 'Horror', 'Science & Technology', 'Education', 'Cookbooks',
    'Religion & Spirituality'
  ];
  ConditionsOptions: string[] = [
    'New', 'Like New', 'Good', 'Acceptable', 'Poor'
  ];
  constructor(
    private booksService: BooksService, 
    private router: Router, 
    private authService: AuthService,
    private modalService: BsModalService
  ) {}

  ngOnInit(): void {
    this.loadMyBooks();
  }

  loadMyBooks(): void {
    this.booksService.getMyBooks().subscribe({
      next: (data) => {
        this.myBooks = data;
      },
      error: (err) => {
        console.error('Error fetching my books:', err);
        this.errorMessage = 'Failed to load your books. Please try again later.';
      }
    });
  }

  searchBooks(): void {

  }

  navigateToAddBook(): void {
    this.router.navigate(['/books/add']);
  }

  viewBookDetails(bookId: number, template: TemplateRef<any>): void {
    this.selectedBook = this.myBooks.find(book => book.bookId === bookId) || this.selectedBook;
    this.modalRef = this.modalService.show(template);
  }

  openUpdateModal(book: Book, template: TemplateRef<any>): void {
    this.selectedBook = { ...book };
    this.modalRef = this.modalService.show(template);
  }

  openAddModal(template: TemplateRef<any>): void {
    this.newBook = { 
      bookId: 0,
      userId: '',
      title: '',
      author: '',
      genre: '',
      condition: '',
      availabilityStatus: true
    };
    this.modalRef = this.modalService.show(template);
  }

  addBook(): void {
    this.booksService.createBook(this.newBook).subscribe({
      next: () => {
        Swal.fire('Added!', 'New book has been added.', 'success');
        this.modalRef?.hide(); 
        this.loadMyBooks(); 
      },
      error: (err) => {
        console.error('Error adding book:', err);
        Swal.fire('Error!', 'There was an error adding the book.', 'error');
      }
    });
  }

  updateBook(): void {
    if (!this.selectedBook || !this.selectedBook.bookId) return;

    this.booksService.updateBook(this.selectedBook.bookId, this.selectedBook).subscribe({
      next: () => {
        Swal.fire('Updated!', 'Book details have been updated.', 'success');
        this.modalRef?.hide(); 
        this.loadMyBooks(); 
      },
      error: (err) => {
        console.error('Error updating book:', err);
        Swal.fire('Error!', 'There was an error updating the book.', 'error');
      }
    });
  }

  confirmDelete(bookId: number): void {
    Swal.fire({
      title: 'Are you sure?',
      text: 'Do you really want to delete this book?',
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#3085d6',
      cancelButtonColor: '#d33',
      confirmButtonText: 'Yes, delete it!'
    }).then((result) => {
      if (result.isConfirmed) {
        this.booksService.deleteBook(bookId).subscribe({
          next: () => {
            Swal.fire('Deleted!', 'Your book has been deleted.', 'success');
            this.loadMyBooks();
          },
          error: (err) => {
            console.error('Error deleting book:', err);
            Swal.fire('Error!', 'There was an error deleting the book.', 'error');
          }
        });
      }
    });
  }

  sortData(key: string): void {
    this.sortKey = key;
    this.sortDirection = !this.sortDirection;

    this.myBooks.sort((a, b) => {
      const valA = (a as any)[key]?.toLowerCase() || '';
      const valB = (b as any)[key]?.toLowerCase() || '';

      if (valA < valB) return this.sortDirection ? -1 : 1;
      if (valA > valB) return this.sortDirection ? 1 : -1;
      return 0;
    });
  }

  get filteredBooks(): Book[] {
    return this.myBooks.filter(book =>
      (book.title?.toLowerCase() || '').includes(this.searchQuery.toLowerCase()) ||
      (book.author?.toLowerCase() || '').includes(this.searchQuery.toLowerCase()) ||
      (book.genre?.toLowerCase() || '').includes(this.searchQuery.toLowerCase())
    );
  }
}
