using Microsoft.AspNetCore.Mvc;
using BookExchangeAPI.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authorization;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;

namespace BookExchangeAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class UsersController : ControllerBase
    {
        private readonly BookExchangeDbContext _context;
        public UsersController(BookExchangeDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<IActionResult> GetUsers()
        {
            /*var userRole = User.FindFirstValue(ClaimTypes.Role); 
            if (userRole != "Admin" || userRole != "User")
            {
                return StatusCode(403, new { message = "You are not authorized to access this resource." }); 
            }*/
            var users = await _context.Users.ToListAsync();
            return Ok(users); 
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetUser(int id)
        {
            var userRole = User.FindFirstValue(ClaimTypes.Role); 
            var userEmail = User.FindFirstValue(ClaimTypes.NameIdentifier); 
           /* if (userRole == "Admin")
            {
                var user = await _context.Users.FindAsync(id);
                if (user == null)
                {
                    return NotFound(new { message = "User not found." }); 
                }
                return Ok(user);
            }
            else if (userRole == "User")
            {
                var user = await _context.Users.FirstOrDefaultAsync(u => u.Email == userEmail);
                if (user == null)
                {
                    return Unauthorized(new { message = "User data could not be validated. Please log in again." });
                }
                if (id != user.UserId)
                {
                    return StatusCode(403, new { message = "You are not authorized to access this resource." });
                }
                return Ok(user);
            }

            if(userRole!=null)
            {
                return Ok(user);
            }
            return StatusCode(403, new { message = "You are not authorized to access this resource." });
            */
            var user = await _context.Users.FindAsync(id);

            return Ok(user);

        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateUser(int id, User user)
        {
            var userRole = User.FindFirstValue(ClaimTypes.Role);
            var userEmail = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var currentUser = await _context.Users.FirstOrDefaultAsync(u => u.Email == userEmail);
            if (currentUser == null)
            {
                return Unauthorized(new { message = "User data could not be validated. Please log in again." });
            }
            if (userRole == "Admin" || (userRole == "User" && id == currentUser.UserId))
            {
                var existingUser = await _context.Users.FindAsync(id);
                if (existingUser == null)
                {
                    return NotFound(new { message = "User not found." });
                }
                existingUser.FullName = user.FullName;
                existingUser.Preferences = user.Preferences;
                existingUser.Address = user.Address;
                existingUser.Bio = user.Bio;
                existingUser.FavoriteGenres = user.FavoriteGenres;
                existingUser.LastUpdatedDatetime = DateTime.UtcNow;
                if (userRole == "Admin")
                {
                    existingUser.Email = user.Email;
                    existingUser.Role = user.Role;
                }

                _context.Entry(existingUser).State = EntityState.Modified;
                await _context.SaveChangesAsync();
                return Ok(new { message = "User updated successfully." });
            }
            return StatusCode(403, new { message = "You are not authorized to access this resource." });
        }

        [HttpPost("change-password")]
        public async Task<IActionResult> ChangePassword(ChangePasswordRequest request)
        {
            var userEmail = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var currentUser = await _context.Users.FirstOrDefaultAsync(u => u.Email == userEmail);
            if (currentUser == null)
            {
                return NotFound(new { message = "User not found." });
            }
            if (!VerifyPassword(request.OldPassword, currentUser.Password))
            {
                return BadRequest(new { message = "Old password is incorrect." });
            }
            currentUser.Password = HashPassword(request.NewPassword);
            currentUser.LastUpdatedDatetime = DateTime.UtcNow;

            _context.Entry(currentUser).State = EntityState.Modified;
            await _context.SaveChangesAsync();
            return Ok(new { message = "Password changed successfully." });
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteUser(int id)
        {
            var userRole = User.FindFirstValue(ClaimTypes.Role);
            if (userRole != "Admin")
            {
                return StatusCode(403, new { message = "You are not authorized to access this resource." });
            }
            var user = await _context.Users.FindAsync(id);
            if (user == null)
            {
                return NotFound(new { message = "User not found." });
            }

            _context.Users.Remove(user);
            await _context.SaveChangesAsync();
            return Ok(new { message = "User deleted successfully." });
        }

        private string HashPassword(string password)
        {
            using (var sha256 = SHA256.Create())
            {
                var bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password));
                return Convert.ToBase64String(bytes);
            }
        }

        private bool VerifyPassword(string password, string storedHash)
        {
            var hashedPassword = HashPassword(password);
            return hashedPassword == storedHash;
        }
    }
}
