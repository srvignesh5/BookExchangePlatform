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
    public class ExchangeRequestsController : ControllerBase
    {
        private readonly BookExchangeDbContext _context;
        public ExchangeRequestsController(BookExchangeDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<ExchangeRequest>>> GetExchangeRequests()
        {
            var userRole = User.FindFirstValue(ClaimTypes.Role); 
            if (userRole != "Admin")
            {
                return StatusCode(403, new { message = "You are not authorized to access this resource." }); 
            }
            var exchangeRequests = await _context.ExchangeRequests.Include(er => er.Book).ToListAsync();
            return Ok(exchangeRequests);
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<ExchangeRequest>> GetExchangeRequest(int id)
        {
            var exchangeRequest = await _context.ExchangeRequests
                .Include(er => er.Book)
                .FirstOrDefaultAsync(er => er.ExchangeRequestId == id);
            if (exchangeRequest == null)
            {
                return NotFound(new { message = "Exchange request not found." });
            }
            var userEmail = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var currentUser = await _context.Users.FirstOrDefaultAsync(u => u.Email == userEmail);
            if (currentUser == null)
            {
                return NotFound(new { message = "User not found." });
            }
            if (User.IsInRole("Admin") || exchangeRequest.SenderId == currentUser.UserId || exchangeRequest.ReceiverId == currentUser.UserId)
            {
                return Ok(exchangeRequest);
            }
            else
            {
                return StatusCode(403, new { message = "You do not have permission to view this exchange request." }); // Return 403 Forbidden
            }
        }

        [HttpGet("myrequests")]
        public async Task<ActionResult<IEnumerable<ExchangeRequest>>> GetMyExchangeRequests()
        {
            var userEmail = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var currentUser = await _context.Users.FirstOrDefaultAsync(u => u.Email == userEmail);
            if (currentUser == null)
            {
                return NotFound(new { message = "User not found." });
            }
            var exchangeRequests = await _context.ExchangeRequests
                .Where(er => er.SenderId == currentUser.UserId || er.ReceiverId == currentUser.UserId)
                .Include(er => er.Book)
                .ToListAsync();
            return Ok(exchangeRequests);
        }
        
        [HttpPost]
        public async Task<ActionResult<ExchangeRequest>> CreateExchangeRequest(ExchangeRequest exchangeRequest)
        {
            var userEmail = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var currentUser = await _context.Users.FirstOrDefaultAsync(u => u.Email == userEmail);
            if (currentUser == null)
            {
                return NotFound(new { message = "User not found." });
            }
            exchangeRequest.SenderId = currentUser.UserId;
            exchangeRequest.Status = "Pending"; 
            exchangeRequest.CreationDatetime =  DateTime.Now;
            exchangeRequest.LastUpdatedDatetime =  DateTime.Now;

            _context.ExchangeRequests.Add(exchangeRequest);
            await _context.SaveChangesAsync();
            return Ok(new { message = "Exchange request created successfully." ,exchangeRequest});
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateExchangeRequest(int id, ExchangeRequest exchangeRequest)
        {
            if (id != exchangeRequest.ExchangeRequestId)
            {
                return BadRequest(new { message = "Invalid request." });
            }
            var existingRequest = await _context.ExchangeRequests.FindAsync(id);
            if (existingRequest == null)
            {
                return NotFound(new { message = "Exchange request not found." });
            }
            var userEmail = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var currentUser = await _context.Users.FirstOrDefaultAsync(u => u.Email == userEmail);
            if (currentUser == null ||
                (existingRequest.SenderId != currentUser.UserId && existingRequest.ReceiverId != currentUser.UserId))
            {
                return StatusCode(403, new { message = "You do not have permission to update this exchange request." });
            }
            existingRequest.NegotiationDetails = exchangeRequest.NegotiationDetails;
            existingRequest.Status = exchangeRequest.Status;
            existingRequest.LastUpdatedDatetime = DateTime.UtcNow;

            await _context.SaveChangesAsync();
            return Ok(new { message = "Exchange request updated successfully." });
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteExchangeRequest(int id)
        {
            var exchangeRequest = await _context.ExchangeRequests.FindAsync(id);
            if (exchangeRequest == null)
            {
                return NotFound(new { message = "Exchange request not found." });
            }

            var messages = await _context.Messages.Where(m => m.ExchangeRequestId == id).ToListAsync();
            var transactionHistories = await _context.TransactionHistories.Where(th => th.ExchangeRequestId == id).ToListAsync();
    
            _context.Messages.RemoveRange(messages);
            _context.TransactionHistories.RemoveRange(transactionHistories);
            _context.ExchangeRequests.Remove(exchangeRequest);

            await _context.SaveChangesAsync();

            return Ok(new { message = "Exchange request deleted successfully." });
        }
    }
}
