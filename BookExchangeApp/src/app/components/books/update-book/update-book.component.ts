import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { Book } from 'src/app/models/book.model';
import { BooksService } from 'src/app/services/books.service';

import Swal from 'sweetalert2';

@Component({
  selector: 'app-update-book',
  templateUrl: './update-book.component.html',
  styleUrls: ['./update-book.component.css']
})
export class UpdateBookComponent implements OnInit {
  public bookId!: number;
  public book: Book = {
    bookId: 0, 
    userId: '', 
    title: '',
    author: '',
    genre: '',
    condition: '',
    availabilityStatus: false
  };

  constructor(
    private route: ActivatedRoute,
    public router: Router, 
    private booksService: BooksService
  ) {}

  ngOnInit(): void {
    this.bookId = Number(this.route.snapshot.paramMap.get('id'));
    this.loadBook();
  }

  loadBook(): void {
    this.booksService.getBookById(this.bookId).subscribe({
      next: (data) => {
        this.book = data; 
      },
      error: (err) => {
        console.error('Error fetching book:', err);
        Swal.fire('Error!', 'Unable to load book details.', 'error');
      }
    });
  }

  updateBook(): void {
    this.booksService.updateBook(this.bookId, this.book).subscribe({
      next: () => {
        Swal.fire('Updated!', 'Book details have been updated.', 'success');
        this.router.navigate(['/books/my-books']); 
      },
      error: (err) => {
        console.error('Error updating book:', err);
        Swal.fire('Error!', 'There was an error updating the book.', 'error');
      }
    });
  }
}
