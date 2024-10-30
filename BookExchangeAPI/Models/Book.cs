namespace BookExchangeAPI.Models
{
    public class Book
    {
        public int BookId { get; set; }
        public required string Title { get; set; }
        public string? Author { get; set; }
        public string? Genre { get; set; }
        public string? Condition { get; set; }
        public bool? AvailabilityStatus { get; set; }
        public int UserId { get; set; }
        public DateTime? LastUpdatedDatetime { get; set; }
        public DateTime? CreationDatetime { get; set; }

        public User? User { get; set; }
    }
}
