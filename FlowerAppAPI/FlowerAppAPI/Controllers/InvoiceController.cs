using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using FlowerAppAPI.Models;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using FlowerAppAPI.DTO;

namespace FlowerAppAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class InvoiceController : ControllerBase
    {
        private readonly FlowerShopDbContext _context;

        public InvoiceController(FlowerShopDbContext context)
        {
            _context = context;
        }
        [HttpGet("{invoiceId}")]
        public async Task<IActionResult> GetInvoice(long invoiceId)
        {
            var invoice = await _context.Invoices
                .Include(i => i.IdorderNavigation)              // Bao gồm thông tin Order
                .ThenInclude(o => o.IduserNavigation)            // Bao gồm thông tin AspNetUser
                .FirstOrDefaultAsync(i => i.Idinvoice == invoiceId);  // Lấy hóa đơn theo Idinvoice

            if (invoice == null)
            {
                return NotFound(new { message = "Invoice not found." });
            }

            var result = new
            {
                invoice.Idinvoice,
                invoice.TotalAmount,
                invoice.BillingDate,
                UserName = invoice.IdorderNavigation.IduserNavigation.UserName,  // Lấy tên người dùng
                UserEmail = invoice.IdorderNavigation.IduserNavigation.Email     // Lấy email người dùng
            };

            return Ok(result);
        }


        //
        [HttpPost("create-order-and-invoice")]
        public async Task<IActionResult> CreateOrderAndInvoice([FromBody] OrderDto orderDto)
        {
            if (orderDto == null || orderDto.TotalAmount <= 0 || string.IsNullOrEmpty(orderDto.IdUser))
            {
                return BadRequest("Invalid data");
            }

            var order = new Order
            {
                Idstatus = 1,
                OrderDate = DateTime.Now,
                TotalAmount = orderDto.TotalAmount,
                Iduser = orderDto.IdUser,
                Idinvoice = 1,
                Idship = 1
            };

            _context.Orders.Add(order);
            await _context.SaveChangesAsync();

            var invoiceDto = new InvoiceDto
            {
                TotalAmount = orderDto.TotalAmount,
                IdOrder = order.Idorder
            };

            var invoice = new Invoice
            {
                TotalAmount = invoiceDto.TotalAmount,
                BillingDate = DateTime.Now,
                CreatedAt = DateTime.Now,
                Idorder = invoiceDto.IdOrder
            };

            _context.Invoices.Add(invoice);
            await _context.SaveChangesAsync();

            return Ok(new { message = "Order and Invoice created successfully!", orderId = order.Idorder, invoiceId = invoice.Idinvoice });
        }
        // GET: api/invoice
        [HttpGet]
        public async Task<ActionResult<IEnumerable<object>>> GetInvoices()
        {
            // Lấy tất cả các hóa đơn với thông tin chi tiết về người dùng và đơn hàng
            var invoices = await _context.Invoices
                .Include(i => i.IdorderNavigation)            // Bao gồm thông tin Order
                .ThenInclude(o => o.IduserNavigation)         // Bao gồm thông tin AspNetUser
                .Select(invoice => new
                {
                    invoice.Idinvoice,
                    invoice.TotalAmount,
                    invoice.BillingDate,
                    UserName = invoice.IdorderNavigation.IduserNavigation.UserName,  // Tên người dùng
                    UserEmail = invoice.IdorderNavigation.IduserNavigation.Email     // Email người dùng
                })
                .ToListAsync();  // Lấy tất cả hóa đơn

            if (!invoices.Any())
            {
                return NotFound(new { message = "No invoices found." });
            }

            return Ok(invoices);  // Trả về danh sách hóa đơn
        }



        // GET: api/invoice/5
        //[HttpGet("{id}")]
        //public async Task<ActionResult<Invoice>> GetInvoice(long id)
        //{
        //    var invoice = await _context.Invoices
        //        .Include(i => i.IdorderNavigation)  // Liên kết với đơn hàng
        //        .Include(i => i.PaymentInvoices)  // Liên kết với các hóa đơn thanh toán
        //        .FirstOrDefaultAsync(i => i.Idinvoice == id);

        //    if (invoice == null)
        //    {
        //        return NotFound();
        //    }

        //    return Ok(invoice);
        //}

        // POST: api/invoice
        [HttpPost]
        public async Task<ActionResult<Invoice>> PostInvoice(Invoice invoice)
        {
            _context.Invoices.Add(invoice);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetInvoice", new { id = invoice.Idinvoice }, invoice);
        }

        // PUT: api/invoice/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutInvoice(long id, Invoice invoice)
        {
            if (id != invoice.Idinvoice)
            {
                return BadRequest();
            }

            _context.Entry(invoice).State = EntityState.Modified;
            await _context.SaveChangesAsync();

            return NoContent();
        }

        // DELETE: api/invoice/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteInvoice(long id)
        {
            var invoice = await _context.Invoices.FindAsync(id);
            if (invoice == null)
            {
                return NotFound();
            }

            _context.Invoices.Remove(invoice);
            await _context.SaveChangesAsync();

            return NoContent();
        }
    }
}
