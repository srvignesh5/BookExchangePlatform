using Microsoft.AspNetCore.Mvc;
using BookExchangeAPI.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authorization;
using System.Security.Claims;

namespace BookExchangeAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class TransactionHistoriesController : ControllerBase
    {
        private readonly BookExchangeDbContext _context;
        public TransactionHistoriesController(BookExchangeDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<TransactionHistory>>> GetTransactionHistories()
        {
            var userRole = User.FindFirstValue(ClaimTypes.Role);
            if (userRole != "Admin")
            {
                return StatusCode(403, new { message = "You are not authorized to access this resource." });
            }
            var transactionHistories = await _context.TransactionHistories
                                                     .Include(th => th.ExchangeRequest)
                                                     .ToListAsync();
            return Ok(transactionHistories);
        }

        [HttpGet("exchange/{exchangeRequestId}")]
        public async Task<IActionResult> GetTransactionHistoriesByExchangeRequestId(int exchangeRequestId)
        {
            var userRole = User.FindFirstValue(ClaimTypes.Role);
            var userEmail = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var currentUser = await _context.Users.FirstOrDefaultAsync(u => u.Email == userEmail);
            if (currentUser == null)
            {
                return Unauthorized(new { message = "User data could not be validated. Please log in again." });
            }
            var isAdmin = userRole == "Admin";
            var isInvolved = await _context.ExchangeRequests
                .AnyAsync(er => er.ExchangeRequestId == exchangeRequestId && 
                                (er.SenderId == currentUser.UserId || er.ReceiverId == currentUser.UserId));
            if (!isAdmin && !isInvolved)
            {
                return StatusCode(403, new { message = "You are not authorized to access these transaction histories." });
            }
            var transactionHistories = await _context.TransactionHistories
                                                     .Where(th => th.ExchangeRequestId == exchangeRequestId)
                                                     .Include(th => th.ExchangeRequest)
                                                     .ToListAsync();

            return Ok(transactionHistories);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetTransactionHistory(int id)
        {
            var transactionHistory = await _context.TransactionHistories
                                                   .Include(th => th.ExchangeRequest)
                                                   .FirstOrDefaultAsync(th => th.TransactionId == id);
            if (transactionHistory == null)
            {
                return NotFound(new { message = "Transaction history not found." });
            }
            var userRole = User.FindFirstValue(ClaimTypes.Role);
            var userEmail = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var currentUser = await _context.Users.FirstOrDefaultAsync(u => u.Email == userEmail);
            if (currentUser == null)
            {
                return Unauthorized(new { message = "User data could not be validated. Please log in again." });
            }
            var isAdmin = userRole == "Admin";
            var isInvolved = transactionHistory.ExchangeRequest != null && 
                             (transactionHistory.ExchangeRequest.SenderId == currentUser.UserId ||
                              transactionHistory.ExchangeRequest.ReceiverId == currentUser.UserId);
            if (!isAdmin && !isInvolved)
            {
                return StatusCode(403, new { message = "You are not authorized to access this transaction history." });
            }
            return Ok(transactionHistory);
        }

        [HttpPost]
        public async Task<ActionResult<TransactionHistory>> CreateTransactionHistory(TransactionHistory transactionHistory)
        {
           /* var userRole = User.FindFirstValue(ClaimTypes.Role);
            var userEmail = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var currentUser = await _context.Users.FirstOrDefaultAsync(u => u.Email == userEmail);
            if (currentUser == null)
            {
                return Unauthorized(new { message = "User data could not be validated. Please log in again." });
            }
            var isAdmin = userRole == "Admin";
            var isValidRequest = await _context.ExchangeRequests
                .AnyAsync(er => er.ExchangeRequestId == transactionHistory.ExchangeRequestId && 
                                (er.SenderId == currentUser.UserId || er.ReceiverId == currentUser.UserId));
            if (!isAdmin && !isValidRequest)
            {
                return StatusCode(403, new { message = "You are not authorized to create this transaction history." });
            }
            transactionHistory.CreationDatetime = DateTime.Now;

            _context.TransactionHistories.Add(transactionHistory);
            await _context.SaveChangesAsync();
            return CreatedAtAction(nameof(GetTransactionHistory), new { id = transactionHistory.TransactionId }, new { message = "Transaction history created successfully." });
            */
            var userEmail = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var currentUser = await _context.Users.FirstOrDefaultAsync(u => u.Email == userEmail);
            if (currentUser == null)
            {
                return Unauthorized(new { transactionHistory = "User data could not be validated. Please log in again." });
            }
            //message.SenderId = currentUser.UserId;
            transactionHistory.CreationDatetime = DateTime.Now;
            _context.TransactionHistories.Add(transactionHistory);
            await _context.SaveChangesAsync();
            return Ok(new { message = "Transaction history created successfully." });
    
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateTransactionHistory(int id, TransactionHistory transactionHistory)
        {
            var existingTransactionHistory = await _context.TransactionHistories
                                                            .Include(th => th.ExchangeRequest)
                                                            .FirstOrDefaultAsync(th => th.TransactionId == id);
            if (existingTransactionHistory == null)
            {
                return NotFound(new { message = "Transaction history not found." });
            }
            var userRole = User.FindFirstValue(ClaimTypes.Role);
            var userEmail = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var currentUser = await _context.Users.FirstOrDefaultAsync(u => u.Email == userEmail);
            if (currentUser == null)
            {
                return Unauthorized(new { message = "User data could not be validated. Please log in again." });
            }
            var isAdmin = userRole == "Admin";
            var isInvolved = existingTransactionHistory.ExchangeRequest != null &&
                             (existingTransactionHistory.ExchangeRequest.SenderId == currentUser.UserId ||
                              existingTransactionHistory.ExchangeRequest.ReceiverId == currentUser.UserId);
            if (!isAdmin && !isInvolved)
            {
                return StatusCode(403, new { message = "You are not authorized to update this transaction history." });
            }
            existingTransactionHistory.Status = transactionHistory.Status;
            existingTransactionHistory.LastUpdatedDatetime = DateTime.UtcNow;

            _context.Entry(existingTransactionHistory).State = EntityState.Modified;
            await _context.SaveChangesAsync();
            return Ok(new { message = "Transaction history updated successfully." });
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteTransactionHistory(int id)
        {
            var userRole = User.FindFirstValue(ClaimTypes.Role);
            if (userRole != "Admin")
            {
                return StatusCode(403, new { message = "You are not authorized to delete this transaction history." });
            }
            var transactionHistory = await _context.TransactionHistories.FindAsync(id);
            if (transactionHistory == null)
            {
                return NotFound(new { message = "Transaction history not found." });
            }

            _context.TransactionHistories.Remove(transactionHistory);
            await _context.SaveChangesAsync();
            return Ok(new { message = "Transaction history deleted successfully." });
        }
    }
}
