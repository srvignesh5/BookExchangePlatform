export interface Message {
    messageId?: number;
    senderId: number;
    receiverId: number;
    exchangeRequestId: number;
    text: string;
    sendDatetime?: Date;
  }
  