namespace BookExchangeAPI.Models
{
    public class ResetPasswordModel
    {
        public required string Email { get; set; }
        public required string NewPassword { get; set; }
    }
}
