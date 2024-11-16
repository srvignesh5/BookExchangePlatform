import { Component, OnInit, TemplateRef } from '@angular/core'; 
import { ExchangeRequest } from 'src/app/models/exchange-request.model';
import { ExchangeRequestsService } from 'src/app/services/exchange-requests.service';
import { Book } from 'src/app/models/book.model';
import { BooksService } from 'src/app/services/books.service';
import { BsModalService, BsModalRef } from 'ngx-bootstrap/modal';
import Swal from 'sweetalert2';
import { Router } from '@angular/router';
import { AuthService } from 'src/app/services/auth.service';
import { User } from 'src/app/models/user.model';
import { UserService } from 'src/app/services/user.service';
import { TransactionHistory } from 'src/app/models/transaction-history.model';
import { TransactionHistoryService } from 'src/app/services/transaction-history.service';
import { ChatComponent } from '../../exchange-requests/chat/chat.component';

@Component({
  selector: 'app-my-exchange',
  templateUrl: './my-exchange.component.html',
  styleUrls: ['./my-exchange.component.css']
})
export class MyExchangeComponent implements OnInit {
  public myExchanges: ExchangeRequest[] = [];
  public searchQuery: string = '';
  public page: number = 1;
  public errorMessage: string = '';
  public sortDirection: boolean = true;
  public sortKey: string = '';
  public currentUserId: any;
  public modalRef?: BsModalRef;
  public selectedExchange: ExchangeRequest = {
    exchangeRequestId: 0,
    bookId: 0,
    senderId: 0,
    receiverId: 0,
    status: ''
  };
  public userMap: { [key: number]: string } = {};
  public transactionStatusMap: { [key: number]: string } = {};
  transactionStatus: { [key: string]: string } = {};
  transactionDetailsModal: TemplateRef<any> | undefined;
  public transactionHistories: TransactionHistory[] = []; 
  constructor(
    private exchangeRequestsService: ExchangeRequestsService,
    private booksService: BooksService, 
    private authService: AuthService,
    private userService: UserService,
    private transactionHistoryService: TransactionHistoryService,
    private router: Router, 
    private modalService: BsModalService
  ) {
    this.currentUserId = this.authService.getUserId();
  }

  ngOnInit(): void {
    this.loadMyExchanges();
  }

  loadMyExchanges(): void {
    this.exchangeRequestsService.getMyExchangeRequests().subscribe({
      next: (data) => {
        this.myExchanges = data;
        this.fetchUserDetails();
        this.fetchTransactionStatuses();
      },
      error: (err) => {
        console.error('Error fetching my exchanges:', err);
        this.errorMessage = 'Failed to load your exchanges. Please try again later.';
      }
    });
  }
  
  fetchUserDetails(): void {
    const userIds = new Set<number>();
    this.myExchanges.forEach(exchange => {
      userIds.add(exchange.senderId);
      userIds.add(exchange.receiverId);
    });
  
    userIds.forEach(id => {
      this.userService.getUserById(id).subscribe({
        next: (user) => {
          this.userMap[id] = `${user.fullName} (${user.userId})`;
        },
        error: (err) => {
          console.error(`Error fetching user with ID ${id}:`, err);
        }
      });
    });
  }
  
  getUserName(id: number): string {
    return this.userMap[id] || 'Loading...';
  }
  fetchTransactionStatuses(): void {
  this.myExchanges.forEach(exchange => {
    if (exchange.exchangeRequestId !== undefined) { 
      this.transactionHistoryService.getTransactionHistoriesByExchangeRequestId(exchange.exchangeRequestId).subscribe({
        next: (transactionHistories: TransactionHistory[]) => {
          if (transactionHistories.length > 0) {
            transactionHistories.sort((a, b) => 
              new Date(b.creationDatetime!).getTime() - new Date(a.creationDatetime!).getTime()
            );
            const latestTransaction = transactionHistories[0];
            this.transactionStatusMap[exchange.exchangeRequestId!] = latestTransaction.status || 'Pending';
          } else {
            this.transactionStatusMap[exchange.exchangeRequestId!] = 'Pending';
          }
        },
        error: (err) => {
          console.error(`Error fetching transaction histories for ExchangeRequest ${exchange.exchangeRequestId}:`, err);
        }
      });
    }
  });
  }

  getLatestTransactionStatus(exchangeRequestId: number | undefined): string {
    return exchangeRequestId !== undefined ? this.transactionStatusMap[exchangeRequestId] || 'Pending' : 'Pending';
  }

  updateStatus(exchange: ExchangeRequest, event: Event): void {
    const selectElement = event.target as HTMLSelectElement;
    if (selectElement && selectElement.value) {
        const newStatus = selectElement.value;
        exchange.status = newStatus;
        this.exchangeRequestsService.updateExchangeRequest(exchange.exchangeRequestId!, exchange).subscribe({
            next: () => {
                if (newStatus === "Accepted") {
                    this.updateBookAvailability(exchange.bookId, false);
                }
                else if((newStatus === "Declined"))
                {
                    this.updateBookAvailability(exchange.bookId, true);
                }
            },
            error: (err) => {
                console.error('Error updating status:', err);
            }
        });
    }
  }

  onTransactionStatusChange(exchange: ExchangeRequest, newStatus: string) {
    this.transactionStatus[exchange.exchangeRequestId!] = newStatus;
    this.createTransaction(exchange, newStatus);
  }

  createTransaction(exchange: ExchangeRequest, newStatus: string): void {
  exchange.status = newStatus;
  if (exchange.exchangeRequestId) {
    const transaction = {
      exchangeRequestId: exchange.exchangeRequestId,
      status: exchange.status
    };
    this.transactionHistoryService.createTransactionHistory(transaction).subscribe({
      next: () => {
        this.loadMyExchanges();
      },
      error: (err) => {
        console.error('Error creating new transaction:', err);
      }
    });
    }else {
      console.error('exchangeRequestId is undefined, cannot create transaction.');
    }
  }

  updateBookAvailability(bookId: number, availabilityStatus: boolean): void {
    this.booksService.getBookById(bookId).subscribe({
        next: (book: Book) => {
            book.availabilityStatus = availabilityStatus;
            this.booksService.updateBook(bookId, book).subscribe({
                next: () => {
                    this.loadMyExchanges();
                },
                error: (err) => {
                    console.error('Error updating book availability:', err);
                }
            });
        },
        error: (err) => {
            console.error('Error fetching book details:', err);
        }
    });
  }

  getStatusColor(status: string): string {
    switch (status) {
      case 'Pending': return 'text-warning';
      case 'Accepted': return 'text-success';
      case 'Declined': return 'text-danger';
      case 'Cancelled': return 'text-danger';
      case 'Requested': return 'text-primary';
      default: return 'text-dark';
    }
  }

  getTransactionStatusColor(status: string): string {
    switch (status) {
      case 'Initiated':
        return '#3498db';
      case 'Payment Initiated':
        return '#f39c12';
      case 'Payment Pending':
        return '#e67e22'; 
      case 'Payment Received':
        return '#2ecc71';
      case 'Shipment Initiated':
        return '#9b59b6';
      case 'Delivered':
        return '#16a085'; 
      case 'Completed':
        return '#28a745'; 
      case 'Cancelled':
        return '#dc3545';
      case 'Refunded':
        return '#8e44ad';
      case 'Refunded Received':
        return '#8e44ad'; 
      case 'Pending':
        return '#f1c40f';
      default:
        return '#000000';
    }
  }

  loadExchangeRequests(): void {
    this.exchangeRequestsService.getMyExchangeRequests().subscribe({
      next: (data) => {
        this.myExchanges = data;
      },
      error: (err) => {
        console.error('Error fetching exchange requests:', err);
      }
    });
  }
  
  isExchangeInitiated(bookId: number): boolean {
    return this.myExchanges.some(req => req.bookId === bookId);
  }


 openChat(bookId: number): void {
  const relevantRequests = this.myExchanges.filter(req => {
    return req.bookId === bookId;
  });

  if (relevantRequests.length > 0) {
    const latestExchangeRequest = relevantRequests
      .filter(req => req.creationDatetime)
      .sort((a, b) => 
        new Date(b.creationDatetime!).getTime() - new Date(a.creationDatetime!).getTime()
      )[0];
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
}
  
  searchExchanges(): void {
    this.myExchanges = this.myExchanges.filter(exchange =>
      (exchange.book?.title.toLowerCase().includes(this.searchQuery.toLowerCase())) ||
      (exchange.book?.author.toLowerCase().includes(this.searchQuery.toLowerCase())) ||
      (exchange.senderId.toString().includes(this.searchQuery)) ||
      (exchange.receiverId.toString().includes(this.searchQuery))
    );
  }

  viewExchangeDetails(exchangeRequestId: number, template: TemplateRef<any>): void {
    this.exchangeRequestsService.getExchangeRequestById(exchangeRequestId).subscribe({
      next: (data) => {
        this.selectedExchange = data;
        this.modalRef = this.modalService.show(template);
      },
      error: (err) => {
        console.error('Error fetching exchange details:', err);
        this.errorMessage = 'Failed to load exchange details. Please try again later.';
      }
    });
  }

  fetchTransactionHistories(exchangeRequestId: number, template: TemplateRef<any>): void {
    this.transactionHistoryService.getTransactionHistoriesByExchangeRequestId(exchangeRequestId).subscribe({
      next: (transactionHistories: TransactionHistory[]) => {
        this.transactionHistories = transactionHistories; 
        this.modalRef = this.modalService.show(template); 
      },
      error: (err) => {
        console.error('Error fetching exchange details:', err);
        this.errorMessage = 'Failed to load transaction histories for ExchangeRequest details. Please try again later.';
      }
    });
  }

  confirmDelete(exchangeId: number | undefined): void {
    if (exchangeId !== undefined) {
      Swal.fire({
        title: 'Are you sure?',
        text: 'Do you really want to delete this exchange request?',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes, delete it!'
      }).then((result) => {
        if (result.isConfirmed) {
          this.exchangeRequestsService.deleteExchangeRequest(exchangeId).subscribe({
            next: () => {
              Swal.fire('Deleted!', 'Your exchange request has been deleted.', 'success');
              this.loadMyExchanges();
            },
            error: (err) => {
              console.error('Error deleting exchange:', err);
              Swal.fire('Error!', 'There was an error deleting the exchange.', 'error');
            }
          });
        }
      });
    } else {
      console.error("Invalid exchangeId:", exchangeId);
    }
  }

  get filteredExchanges(): ExchangeRequest[] {
    return this.myExchanges.filter(exchange =>
      (exchange.book?.title?.toLowerCase().includes(this.searchQuery.toLowerCase())) ||
      (exchange.book?.author?.toLowerCase().includes(this.searchQuery.toLowerCase())) ||
      (this.getUserName(exchange.senderId).toLowerCase().includes(this.searchQuery.toLowerCase())) ||
      (this.getUserName(exchange.receiverId).toLowerCase().includes(this.searchQuery.toLowerCase()))
    );
  }

  sortData(key: string): void {
    this.sortKey = key;
    this.sortDirection = !this.sortDirection;
  
    this.myExchanges.sort((a, b) => {
      const valA = (typeof (a as any)[key] === 'string' ? (a as any)[key].toLowerCase() : (a as any)[key]) || '';
      const valB = (typeof (b as any)[key] === 'string' ? (b as any)[key].toLowerCase() : (b as any)[key]) || '';
  
      if (valA < valB) return this.sortDirection ? -1 : 1;
      if (valA > valB) return this.sortDirection ? 1 : -1;
      return 0;
    });
  }
}
