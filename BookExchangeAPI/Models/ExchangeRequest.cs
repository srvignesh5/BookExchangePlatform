namespace BookExchangeAPI.Models
{
    public class ExchangeRequest
    {
        public int ExchangeRequestId { get; set; }
        public int SenderId { get; set; }
        public int ReceiverId { get; set; }
        public int BookId { get; set; }
        public string? Status { get; set; }
        public string? NegotiationDetails { get; set; }
        public DateTime? LastUpdatedDatetime { get; set; }
        public DateTime? CreationDatetime { get; set; }
        public Book? Book { get; set; }
    }
}
