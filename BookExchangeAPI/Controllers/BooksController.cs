using Microsoft.AspNetCore.Mvc;
using BookExchangeAPI.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authorization;
using System.Security.Claims;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace BookExchangeAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class BooksController : ControllerBase
    {
        private readonly BookExchangeDbContext _context;
        public BooksController(BookExchangeDbContext context)
        {
            _context = context;
        }
        
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Book>>> GetBooks()
        {
            var books = await _context.Books.Include(b => b.User).ToListAsync();
            return Ok(books);
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<Book>> GetBook(int id)
        {
            var book = await _context.Books.Include(b => b.User).FirstOrDefaultAsync(b => b.BookId == id);
            if (book == null)
            {
                return NotFound(new { message = "Book not found." });
            }
            return Ok(book);
        }

        [HttpGet("mybooks")]
        public async Task<ActionResult<IEnumerable<Book>>> MyBooks()
        {
            var userEmail = User.FindFirstValue(ClaimTypes.NameIdentifier); 
            var currentUser = await _context.Users.FirstOrDefaultAsync(u => u.Email == userEmail);
            if (currentUser == null)
            {
                return NotFound(new { message = "User not found." });
            }
            var books = await _context.Books
                .Where(b => b.UserId == currentUser.UserId) 
                .Include(b => b.User)
                .ToListAsync();

            return Ok(books);
        }

        [HttpPost]
        public async Task<ActionResult<Book>> CreateBook(Book book)
        {
            var userEmail = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var currentUser = await _context.Users.FirstOrDefaultAsync(u => u.Email == userEmail);
            if (currentUser == null)
            {
                return NotFound(new { message = "User not found." });
            }
            book.UserId = currentUser.UserId;
            book.CreationDatetime = DateTime.UtcNow; 
            book.LastUpdatedDatetime = DateTime.UtcNow;

            _context.Books.Add(book);
            await _context.SaveChangesAsync();
            return Ok(new { message = "Book created successfully." });
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateBook(int id, Book book)
        {
            if (id != book.BookId)
            {
                return BadRequest(new { message = "Book ID mismatch." });
            }
            var userEmail = User.FindFirstValue(ClaimTypes.NameIdentifier); 
            var currentUser = await _context.Users.FirstOrDefaultAsync(u => u.Email == userEmail);
            if (currentUser == null)
            {
                return NotFound(new { message = "User not found." });
            }
            var existingBook = await _context.Books.FindAsync(id);
            if (existingBook == null)
            {
                return NotFound(new { message = "Book not found." });
            }
            if (User.IsInRole("Admin") || User.IsInRole("User") || existingBook.UserId == currentUser.UserId)
            {
                existingBook.Title = book.Title;
                existingBook.Author = book.Author;
                existingBook.Genre = book.Genre;
                existingBook.Condition = book.Condition;
                existingBook.AvailabilityStatus = book.AvailabilityStatus;
                existingBook.LastUpdatedDatetime = DateTime.UtcNow;

                await _context.SaveChangesAsync();
                return Ok(new { message = "Book updated successfully." });
            }
            else
            {
                return StatusCode(403, new { message = "You do not have permission to update this book." });
            }
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteBook(int id)
        {
            var userEmail = User.FindFirstValue(ClaimTypes.NameIdentifier); 
            var currentUser = await _context.Users.FirstOrDefaultAsync(u => u.Email == userEmail);
            if (currentUser == null)
            {
                return NotFound(new { message = "User not found." });
            }
            var book = await _context.Books.FindAsync(id);
            if (book == null)
            {
                return NotFound(new { message = "Book not found." });
            }
            if (User.IsInRole("Admin") || book.UserId == currentUser.UserId)
            {
                _context.Books.Remove(book);
                await _context.SaveChangesAsync();
                return Ok(new { message = "Book deleted successfully." });
            }
            else
            {
                return StatusCode(403, new { message = "You do not have permission to delete this book." });
            }
        }
    }
}
