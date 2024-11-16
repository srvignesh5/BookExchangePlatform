export interface ExchangeRequest {
    exchangeRequestId?: number;
    senderId: number;
    receiverId: number;
    bookId: number;
    status: string;
    negotiationDetails?: string;
    lastUpdatedDatetime?: Date;
    creationDatetime?: Date;
    book?: any;
  }
  