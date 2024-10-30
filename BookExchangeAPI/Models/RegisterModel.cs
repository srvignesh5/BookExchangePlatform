using System.ComponentModel.DataAnnotations;

namespace BookExchangeAPI.Models
{
    public class RegisterModel
    {
        [Required(ErrorMessage = "Role is required.")] 
        [RegularExpression("^(Admin|User)$", ErrorMessage = "Role must be either 'Admin' or 'User'.")]
        public required string Role { get; set; }

        [Required(ErrorMessage = "Full name is required.")]
        [StringLength(100, ErrorMessage = "Full name cannot exceed 100 characters.")]
        public string? FullName { get; set; }

        [Required(ErrorMessage = "Email is required.")]
        [EmailAddress(ErrorMessage = "Invalid email address.")]
        public required string Email { get; set; } 

        [Required(ErrorMessage = "Password is required.")]
        [MinLength(6, ErrorMessage = "Password must be at least 6 characters long.")]
        public required string Password { get; set; }

        [StringLength(200, ErrorMessage = "Preferences cannot exceed 200 characters.")]
        public string? Preferences { get; set; }

        [StringLength(200, ErrorMessage = "Address cannot exceed 200 characters.")]
        public string? Address { get; set; }

        [StringLength(500, ErrorMessage = "Bio cannot exceed 500 characters.")]
        public string? Bio { get; set; } 

        [StringLength(100, ErrorMessage = "Favorite genres cannot exceed 100 characters.")]
        public string? FavoriteGenres { get; set; } 
    }
}
