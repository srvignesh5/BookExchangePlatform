import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { Book } from 'src/app/models/book.model';
import { BooksService } from 'src/app/services/books.service';

import Swal from 'sweetalert2';

@Component({
  selector: 'app-add-book',
  templateUrl: './add-book.component.html',
  styleUrls: ['./add-book.component.css']
})
export class AddBookComponent {
  public book: Book = {
    bookId: 0, 
    userId: '', 
    title: '',
    author: '',
    genre: '',
    condition: '',
    availabilityStatus: true
  };

  constructor(private booksService: BooksService, private router: Router) {}

  addBook(): void {
    this.booksService.createBook(this.book).subscribe({
      next: () => {
        Swal.fire('Success!', 'Your book has been added.', 'success').then(() => {
          this.router.navigate(['/my-books']);
        });
      },
      error: (err) => {
        console.error('Error adding book:', err);
        Swal.fire('Error!', 'There was an error adding the book.', 'error');
      }
    });
  }
}
