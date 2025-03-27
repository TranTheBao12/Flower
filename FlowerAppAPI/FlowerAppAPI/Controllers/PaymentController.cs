using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using FlowerAppAPI.Models;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace FlowerAppAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PaymentController : ControllerBase
    {
        private readonly FlowerShopDbContext _context;

        public PaymentController(FlowerShopDbContext context)
        {
            _context = context;
        }

        // GET: api/payment
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Payment>>> GetPayments()
        {
            var payments = await _context.Payments
                .Include(p => p.IduserNavigation)  // Liên kết với người dùng
                .Include(p => p.PaymentInvoices)  // Liên kết với hóa đơn thanh toán
                .ToListAsync();

            return Ok(payments);
        }

        // GET: api/payment/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Payment>> GetPayment(long id)
        {
            var payment = await _context.Payments
                .Include(p => p.IduserNavigation)  // Liên kết với người dùng
                .Include(p => p.PaymentInvoices)  // Liên kết với hóa đơn thanh toán
                .FirstOrDefaultAsync(p => p.Idpayment == id);

            if (payment == null)
            {
                return NotFound();
            }

            return Ok(payment);
        }

        // POST: api/payment
        [HttpPost]
        public async Task<ActionResult<Payment>> PostPayment(Payment payment)
        {
            _context.Payments.Add(payment);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetPayment", new { id = payment.Idpayment }, payment);
        }

        // PUT: api/payment/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutPayment(long id, Payment payment)
        {
            if (id != payment.Idpayment)
            {
                return BadRequest();
            }

            _context.Entry(payment).State = EntityState.Modified;
            await _context.SaveChangesAsync();

            return NoContent();
        }

        // DELETE: api/payment/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeletePayment(long id)
        {
            var payment = await _context.Payments.FindAsync(id);
            if (payment == null)
            {
                return NotFound();
            }

            _context.Payments.Remove(payment);
            await _context.SaveChangesAsync();

            return NoContent();
        }
    }
}
