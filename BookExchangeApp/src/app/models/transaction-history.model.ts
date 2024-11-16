export interface TransactionHistory {
    transactionId?: number;
    exchangeRequestId: number;
    status?: string;
    lastUpdatedDatetime?: Date;
    creationDatetime?: Date;
  }