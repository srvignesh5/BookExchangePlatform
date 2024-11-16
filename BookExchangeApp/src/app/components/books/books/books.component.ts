import { Component, OnInit, TemplateRef } from '@angular/core';
import { Router } from '@angular/router';
import { Book } from 'src/app/models/book.model';
import { BooksService } from 'src/app/services/books.service';
import { MessageService } from 'src/app/services/message.service';
import { AuthService } from 'src/app/services/auth.service';
import { ExchangeRequestsService } from 'src/app/services/exchange-requests.service'; 
import { BsModalService, BsModalRef } from 'ngx-bootstrap/modal';
import Swal from 'sweetalert2';
import { ExchangeRequest } from 'src/app/models/exchange-request.model';
import { UserService } from 'src/app/services/user.service'; 
import { ChatComponent } from '../../exchange-requests/chat/chat.component';
import { Message } from 'src/app/models/message.model';

@Component({
  selector: 'app-books',
  templateUrl: './books.component.html',
  styleUrls: ['./books.component.css']
})
export class BooksComponent implements OnInit {
  public books: Book[] = [];
  public searchQuery: string = '';
  public page: number = 1;
  public errorMessage: string = '';
  public sortDirection: boolean = true;
  public sortKey: string = '';
  public isAdmin: boolean = false;
  public modalRef?: BsModalRef;
  public selectedBook?: Book;
  public negotiationDetails: string = '';
  public currentUserId: any;
  public exchangeRequests: ExchangeRequest[] = []; 

  constructor(
    private booksService: BooksService, 
    private userService: UserService,
    private messageService: MessageService,
    private router: Router, 
    private authService: AuthService,
    private exchangeRequestsService: ExchangeRequestsService,
    private modalService: BsModalService
  ) {}

  ngOnInit(): void {
    this.loadBooks();
    this.checkUserRole();
    this.currentUserId = this.userService.getUserId(); 
    this.loadExchangeRequests(); 
}

  loadBooks(): void {
    this.booksService.getAllBooks().subscribe({
      next: (data) => {
       this.books = data;
      },
      error: (err) => {
        console.error('Error fetching books:', err);
        this.errorMessage = 'Failed to load books. Please try again later.';
      }
    });
  }

  loadExchangeRequests(): void {
    this.exchangeRequestsService.getMyExchangeRequests().subscribe({
      next: (data) => {
        this.exchangeRequests = data; 
      },
      error: (err) => {
        console.error('Error fetching exchange requests:', err);
      }
    });
  }

  isExchangeInitiated(bookId: number): boolean {
    return this.exchangeRequests.some(req => req.bookId === bookId );
  }

  openChat(bookId: number): void {
    if (!this.exchangeRequests || this.exchangeRequests.length === 0) {
      console.error('Exchange requests are not loaded yet.');
      return;
    }

    const relevantRequests = this.exchangeRequests.filter(req => req.bookId === bookId);

    if (relevantRequests.length > 0) {
      const latestExchangeRequest = relevantRequests
        .filter(req => req.creationDatetime)
        .sort((a, b) => new Date(b.creationDatetime!).getTime() - new Date(a.creationDatetime!).getTime())[0];

      if (latestExchangeRequest) {
        this.modalRef = this.modalService.show(ChatComponent, {
          initialState: {
            exchangeRequestId: latestExchangeRequest.exchangeRequestId
          },
          class: 'modal-lg'
        });
      } else {
        console.error('No valid exchange request found for this book.');
      }
    } else {
      console.error('No exchange request found for this book.');
    }
  }
  
  checkUserRole(): void {
   this.isAdmin = this.authService.isAdmin();
  }

  bookExchangeModal(bookId: number, template: TemplateRef<any>): void {
    this.selectedBook = this.books.find(book => book.bookId === bookId);
    this.modalRef = this.modalService.show(template);
  }

  public openBookExchangeModal(template: TemplateRef<any>, book: Book): void {
    this.selectedBook = book;
    this.negotiationDetails = '';
    this.modalRef = this.modalService.show(template);
  }

  sendExchangeRequest(): void {
    if (this.selectedBook && this.negotiationDetails.trim()) {
      const senderId = this.authService.getUserId(); 
      const receiverId = this.selectedBook.userId; 
      
      if (senderId && receiverId) {
        const exchangeRequest: ExchangeRequest = {
          senderId: +senderId,
          receiverId: +receiverId,
          bookId: this.selectedBook.bookId,
          status: 'Pending',
          negotiationDetails: this.negotiationDetails
        };

        this.exchangeRequestsService.createExchangeRequest(exchangeRequest).subscribe({
          next: (response) => {
          const message: Message = {
            senderId: +response.exchangeRequest.senderId ,
            receiverId: +response.exchangeRequest.receiverId,
            exchangeRequestId: response.exchangeRequest.exchangeRequestId,
            text: this.negotiationDetails.trim() 
          };

          this.messageService.createMessage(message).subscribe({
          next: () => {}});

            Swal.fire('Success!', 'Exchange request sent successfully.', 'success');
            this.modalRef?.hide();
            this.router.navigate(['/my-exchange']);
          },
          error: (err) => {
            console.error('Error creating exchange request:', err);
            Swal.fire('Error!', 'Failed to send exchange request. Please try again.', 'error');
          }
        });
      } else {
        Swal.fire('Error!', 'Invalid sender or receiver information.', 'error');
      }
    } else {
      Swal.fire('Error!', 'Please provide negotiation details.', 'error');
    }
  }

  searchBooks(): void {
  }

  viewBookDetails(bookId: number, template: TemplateRef<any>): void {
    this.selectedBook = this.books.find(book => book.bookId === bookId);
    this.modalRef = this.modalService.show(template);
    this.currentUserId = this.userService.getUserId();
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
            this.loadBooks();
          },
          error: (err) => {
            console.error('Error deleting book:', err);
            Swal.fire('Error!', 'There was an error deleting the book.', 'error');
          }
        });
      }
    });
  }

  get filteredBooks(): Book[] {
    return this.books.filter(book =>
      (book.title?.toLowerCase() || '').includes(this.searchQuery.toLowerCase()) ||
      (book.author?.toLowerCase() || '').includes(this.searchQuery.toLowerCase()) ||
      (book.genre?.toLowerCase() || '').includes(this.searchQuery.toLowerCase())
    );
  }

  sortData(key: string): void {
    this.sortKey = key;
    this.sortDirection = !this.sortDirection;

    this.books.sort((a, b) => {
      const valA = (a as any)[key]?.toLowerCase() || '';
      const valB = (b as any)[key]?.toLowerCase() || '';

      if (valA < valB) return this.sortDirection ? -1 : 1;
      if (valA > valB) return this.sortDirection ? 1 : -1;
      return 0;
    });
  }
}