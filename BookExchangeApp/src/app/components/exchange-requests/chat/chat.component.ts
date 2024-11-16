import { Component, OnInit, OnDestroy, ViewChild, ElementRef } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { MessageService } from 'src/app/services/message.service';
import { AuthService } from 'src/app/services/auth.service';
import { ExchangeRequestsService } from 'src/app/services/exchange-requests.service';
import { TransactionHistoryService } from 'src/app/services/transaction-history.service';
import { Message } from 'src/app/models/message.model';
import { ExchangeRequest } from 'src/app/models/exchange-request.model';
import { TransactionHistory } from 'src/app/models/transaction-history.model';
import { BsModalRef } from 'ngx-bootstrap/modal';

@Component({
  selector: 'app-chat',
  templateUrl: './chat.component.html',
  styleUrls: ['./chat.component.css']
})
export class ChatComponent implements OnInit, OnDestroy {
  @ViewChild('chatBody') chatBody!: ElementRef;

  exchangeRequestId!: number;
  messages: Message[] = [];
  exchangeRequests: ExchangeRequest[] = [];
  newMessage = '';
  selectedStatus = 'normal';
  currentUserId: any;
  receiverId: any;
  SenderId: any;
  private pollingInterval: any;

  constructor(
    private route: ActivatedRoute,
    private messageService: MessageService,
    private authService: AuthService,
    private bsModalRef: BsModalRef,
    private exchangeRequestsService: ExchangeRequestsService,
    private router: Router,
    private transactionHistoryService: TransactionHistoryService
  ) {
    this.exchangeRequestId = +this.route.snapshot.params['exchangeRequestId'];
    this.currentUserId = this.authService.getUserId();
  }

  ngOnInit(): void {
    this.loadExchangeRequests();
    this.loadMessages();
    this.pollingInterval = setInterval(() => this.loadMessages(), 500);
  }

  ngOnDestroy(): void {
    if (this.pollingInterval) clearInterval(this.pollingInterval);
  }

  close(): void {
    this.bsModalRef.hide();
  }
  
  loadMessages(): void {
    this.messageService.getMessagesByExchangeRequestId(this.exchangeRequestId).subscribe({
      next: data => {
        this.messages = data;
        this.sortMessages();
        this.scrollToBottom();
      },
      error: err => console.error('Error fetching messages:', err)
    });
  }

  loadExchangeRequests(): void {
    this.exchangeRequestsService.getMyExchangeRequests().subscribe({
      next: data => {
        this.exchangeRequests = data;
        this.SenderId = this.exchangeRequests.find(
          exchange => exchange.exchangeRequestId === this.exchangeRequestId
        )?.senderId;
      },
      error: err => console.error('Error fetching exchange requests:', err)
    });
  }

  sendMessage(): void {
    if (!this.newMessage.trim()) return;

    const exchange = this.exchangeRequests.find(
      exchange => exchange.exchangeRequestId === this.exchangeRequestId
    );

    if (!exchange) {
      console.error(`No receiver found for exchangeRequestId: ${this.exchangeRequestId}`);
      return;
    }

    const message: Message = {
      senderId: this.currentUserId,
      receiverId: exchange.senderId === this.currentUserId ? exchange.receiverId : exchange.senderId,
      exchangeRequestId: this.exchangeRequestId,
      text: this.newMessage.trim(),
    };

    this.messageService.createMessage(message).subscribe({
      next: () => {
        this.newMessage = '';
        this.loadMessages();
        if (this.selectedStatus !== 'normal') {
          const transactionHistory: TransactionHistory = {
            exchangeRequestId: this.exchangeRequestId,
            status: this.selectedStatus,
          };

          this.transactionHistoryService.createTransactionHistory(transactionHistory).subscribe({
            next: () => console.log('Transaction recorded successfully.'),
            error: err => console.error('Error recording transaction:', err)
          });
        }
      },
      error: err => console.error('Error sending message:', err)
    });
  }

  cancelMessage(): void {
    this.router.navigate(['/my-exchange']);
  }

  private sortMessages(): void {
    this.messages.sort((a, b) => new Date(a.sendDatetime || 0).getTime() - new Date(b.sendDatetime || 0).getTime());
  }

  private scrollToBottom(): void {
    setTimeout(() => {
      if (this.chatBody) this.chatBody.nativeElement.scrollTop = this.chatBody.nativeElement.scrollHeight;
    }, 5000);
  }
}
