namespace BookExchangeAPI.Models
{
    public class User
    {
        public int UserId { get; set; }
        public string? Role { get; set; }
        public string? FullName { get; set; }
        public required string Email { get; set; }
        public required string Password { get; set; }
        public string? Preferences { get; set; }
        public string? Address { get; set; }
        public string? Bio { get; set; } 
        public string? FavoriteGenres { get; set; } 
        public DateTime? LastUpdatedDatetime { get; set; } 
        public DateTime? CreationDatetime { get; set; }
    }
}
