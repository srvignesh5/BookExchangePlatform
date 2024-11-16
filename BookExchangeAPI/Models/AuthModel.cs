using System.ComponentModel.DataAnnotations;

namespace BookExchangeAPI.Models
{
    public class AuthModel
    {
        [Required(ErrorMessage = "Email is required.")]
        [EmailAddress(ErrorMessage = "Invalid email address.")]
        public required string Email { get; set; }

        [Required(ErrorMessage = "Password is required.")]
        public required string Password { get; set; } 
    }
}
