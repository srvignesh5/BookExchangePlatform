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
    public class MessagesController : ControllerBase
    {
        private readonly BookExchangeDbContext _context;
        public MessagesController(BookExchangeDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<Message>>> GetMessages()
        {
            var userRole = User.FindFirstValue(ClaimTypes.Role);
            if (userRole != "Admin")
            {
                return StatusCode(403, new { message = "You are not authorized to access this resource." });
            }
            var messages = await _context.Messages.Include(m => m.ExchangeRequest).ToListAsync();
            return Ok(messages);
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<Message>> GetMessageById(int id)
        {
            var userRole = User.FindFirstValue(ClaimTypes.Role);
            var userEmail = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var currentUser = await _context.Users.FirstOrDefaultAsync(u => u.Email == userEmail);
            if (currentUser == null)
            {
                return Unauthorized(new { message = "User data could not be validated. Please log in again." });
            }
            var message = await _context.Messages
                .Include(m => m.ExchangeRequest)
                .FirstOrDefaultAsync(m => m.MessageId == id);
            if (message == null)
            {
                return NotFound(new { message = "Message not found." });
            }
            if (userRole != "Admin" && message.SenderId != currentUser.UserId && message.ReceiverId != currentUser.UserId)
            {
                return StatusCode(403, new { message = "You are not authorized to access this message." });
            }
            return Ok(message);
        }

        [HttpGet("exchange/{exchangeRequestId}")]
        public async Task<ActionResult<IEnumerable<Message>>> GetMessagesByExchangeRequestId(int exchangeRequestId)
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
                return StatusCode(403, new { message = "You are not authorized to access these messages." });
            }
            var messages = await _context.Messages
                .Where(m => m.ExchangeRequestId == exchangeRequestId)
                .Include(m => m.ExchangeRequest)
                .ToListAsync();
            return Ok(messages);
        }

        [HttpPost]
        public async Task<ActionResult<Message>> CreateMessage(Message message)
        {
            var userEmail = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var currentUser = await _context.Users.FirstOrDefaultAsync(u => u.Email == userEmail);
            if (currentUser == null)
            {
                return Unauthorized(new { message = "User data could not be validated. Please log in again." });
            }
            //message.SenderId = currentUser.UserId;
            message.SendDatetime = DateTime.Now;

            _context.Messages.Add(message);
            await _context.SaveChangesAsync();
            return Ok(new { message = "Message sent successfully." });
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateMessage(int id, Message message)
        {
            if (id != message.MessageId)
            {
                return BadRequest(new { message = "Invalid request." });
            }
            var userRole = User.FindFirstValue(ClaimTypes.Role);
            var userEmail = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var currentUser = await _context.Users.FirstOrDefaultAsync(u => u.Email == userEmail);
            if (currentUser == null)
            {
                return Unauthorized(new { message = "User data could not be validated. Please log in again." });
            }
            var existingMessage = await _context.Messages.FindAsync(id);
            if (existingMessage == null)
            {
                return NotFound(new { message = "Message not found." });
            }
            if (userRole != "Admin" && existingMessage.SenderId != currentUser.UserId)
            {
                return StatusCode(403, new { message = "You are not authorized to update this message." });
            }

            existingMessage.Text = message.Text;
            await _context.SaveChangesAsync();
            return Ok(new { message = "Message updated successfully." });
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteMessage(int id)
        {
            var userRole = User.FindFirstValue(ClaimTypes.Role);
            if (userRole != "Admin")
            {
                return StatusCode(403, new { message = "You are not authorized to delete this message." });
            }
            var message = await _context.Messages.FindAsync(id);
            if (message == null)
            {
                return NotFound(new { message = "Message not found." });
            }
            _context.Messages.Remove(message);
            await _context.SaveChangesAsync();
            return Ok(new { message = "Message deleted successfully." });
        }
    }
}
