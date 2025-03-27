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
    public class OrderDetailController : ControllerBase
    {
        private readonly FlowerShopDbContext _context;

        public OrderDetailController(FlowerShopDbContext context)
        {
            _context = context;
        }

        // GET: api/orderdetail
        [HttpGet]
        public async Task<ActionResult<IEnumerable<OrderDetail>>> GetOrderDetails()
        {
            var orderDetails = await _context.OrderDetails
                .Include(od => od.IdorderNavigation)  // Liên kết với đơn hàng
             // Liên kết với sản phẩm
                .ToListAsync();

            return Ok(orderDetails);
        }

        // GET: api/orderdetail/5
        [HttpGet("{id}")]
        public async Task<ActionResult<OrderDetail>> GetOrderDetail(long id)
        {
            var orderDetail = await _context.OrderDetails
                .Include(od => od.IdorderNavigation)  // Liên kết với đơn hàng
                  // Liên kết với sản phẩm
                .FirstOrDefaultAsync(od => od.Idorder == id);

            if (orderDetail == null)
            {
                return NotFound();
            }

            return Ok(orderDetail);
        }

        // POST: api/orderdetail
        [HttpPost]
        public async Task<ActionResult<OrderDetail>> PostOrderDetail(OrderDetail orderDetail)
        {
            _context.OrderDetails.Add(orderDetail);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetOrderDetail", new { id = orderDetail.Idorder }, orderDetail);
        }

        // PUT: api/orderdetail/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutOrderDetail(long id, OrderDetail orderDetail)
        {
            if (id != orderDetail.Idorder)
            {
                return BadRequest();
            }

            _context.Entry(orderDetail).State = EntityState.Modified;
            await _context.SaveChangesAsync();

            return NoContent();
        }

        // DELETE: api/orderdetail/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteOrderDetail(long id)
        {
            var orderDetail = await _context.OrderDetails.FindAsync(id);
            if (orderDetail == null)
            {
                return NotFound();
            }

            _context.OrderDetails.Remove(orderDetail);
            await _context.SaveChangesAsync();

            return NoContent();
        }
    }
}
