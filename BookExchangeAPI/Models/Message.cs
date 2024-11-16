namespace BookExchangeAPI.Models
{
    public class Message
    {
        public int MessageId { get; set; }
        public int SenderId { get; set; }
        public int ReceiverId { get; set; }
        public int ExchangeRequestId { get; set; }
        public string? Text { get; set; }
        public DateTime? SendDatetime { get; set; }
        public ExchangeRequest? ExchangeRequest { get; set; }
    }
}
