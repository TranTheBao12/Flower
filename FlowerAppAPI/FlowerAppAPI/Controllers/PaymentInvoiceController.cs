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
    public class PaymentInvoiceController : ControllerBase
    {
        private readonly FlowerShopDbContext _context;

        public PaymentInvoiceController(FlowerShopDbContext context)
        {
            _context = context;
        }

        // GET: api/paymentinvoice
        [HttpGet]
        public async Task<ActionResult<IEnumerable<PaymentInvoice>>> GetPaymentInvoices()
        {
            var paymentInvoices = await _context.PaymentInvoices
                .Include(pi => pi.IdinvoiceNavigation)  // Liên kết với hóa đơn
                .Include(pi => pi.IdpaymentNavigation)  // Liên kết với thanh toán
                .ToListAsync();

            return Ok(paymentInvoices);
        }

        // GET: api/paymentinvoice/5
        [HttpGet("{id}")]
        public async Task<ActionResult<PaymentInvoice>> GetPaymentInvoice(long id)
        {
            var paymentInvoice = await _context.PaymentInvoices
                .Include(pi => pi.IdinvoiceNavigation)  // Liên kết với hóa đơn
                .Include(pi => pi.IdpaymentNavigation)  // Liên kết với thanh toán
                .FirstOrDefaultAsync(pi => pi.Idpayment == id);

            if (paymentInvoice == null)
            {
                return NotFound();
            }

            return Ok(paymentInvoice);
        }

        // POST: api/paymentinvoice
        [HttpPost]
        public async Task<ActionResult<PaymentInvoice>> PostPaymentInvoice(PaymentInvoice paymentInvoice)
        {
            _context.PaymentInvoices.Add(paymentInvoice);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetPaymentInvoice", new { id = paymentInvoice.Idpayment }, paymentInvoice);
        }

        // PUT: api/paymentinvoice/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutPaymentInvoice(long id, PaymentInvoice paymentInvoice)
        {
            if (id != paymentInvoice.Idpayment)
            {
                return BadRequest();
            }

            _context.Entry(paymentInvoice).State = EntityState.Modified;
            await _context.SaveChangesAsync();

            return NoContent();
        }

        // DELETE: api/paymentinvoice/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeletePaymentInvoice(long id)
        {
            var paymentInvoice = await _context.PaymentInvoices.FindAsync(id);
            if (paymentInvoice == null)
            {
                return NotFound();
            }

            _context.PaymentInvoices.Remove(paymentInvoice);
            await _context.SaveChangesAsync();

            return NoContent();
        }
    }
}
