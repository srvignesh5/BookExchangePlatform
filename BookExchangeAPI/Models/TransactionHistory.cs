namespace BookExchangeAPI.Models
{
    public class TransactionHistory
    {
        public int TransactionId { get; set; }
        public int ExchangeRequestId { get; set; }
        public string? Status { get; set; }
        public DateTime? LastUpdatedDatetime { get; set; }
        public DateTime? CreationDatetime { get; set; }
        public ExchangeRequest? ExchangeRequest { get; set; }
    }
}
