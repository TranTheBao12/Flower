using Microsoft.AspNetCore.Mvc;
using FlowerAppAPI.Models;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace FlowerAppAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CartController : ControllerBase
    {
        private readonly FlowerShopDbContext _context;

        public CartController(FlowerShopDbContext context)
        {
            _context = context;
        }

        // GET: api/cart
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Cart>>> GetCarts()
        {
            var carts = await _context.Carts.Include(c => c.IduserNavigation).ToListAsync();
            return Ok(carts);
        }

        // GET: api/cart/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Cart>> GetCart(long id)
        {
            var cart = await _context.Carts.Include(c => c.IduserNavigation)
                                           .FirstOrDefaultAsync(c => c.Idcart == id);

            if (cart == null)
            {
                return NotFound();
            }

            return Ok(cart);
        }
        [HttpGet("GetCartItems/{userId}")]
        public async Task<IActionResult> GetCartItems(string userId)
        {
            try
            {
                // Lấy tất cả các sản phẩm trong giỏ hàng của người dùng với userId đã cho
                var cartItems = await _context.Carts
                    .Where(c => c.Iduser == userId) // Tìm các sản phẩm trong giỏ của người dùng
                    .Include(c => c.IdproductNavigation) // Bao gồm thông tin sản phẩm
                    .ToListAsync();

                if (cartItems == null || cartItems.Count == 0)
                {
                    return NotFound(new { Message = "No items found in the cart for this user." });
                }

                // Chỉ trả về thông tin sản phẩm, số lượng và ngày thêm vào giỏ hàng
                var cartDetails = cartItems.Select(c => new
                {
                    c.Idcart,
                    c.Quanlity,
                    c.AddedDate,
                    Product = new
                    {
                        c.IdproductNavigation.Idproduct,
                        c.IdproductNavigation.Name,
                        c.IdproductNavigation.Description,
                        c.IdproductNavigation.Price,
                        c.IdproductNavigation.Image
                    }
                }).ToList();

                return Ok(cartDetails);
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"An error occurred while fetching the cart items: {ex.Message}");
            }
        }
        [HttpPost("DeleteItem/{cartId}")]
        public async Task<IActionResult> SaveItem(long cartId)
        {
            try
            {
                var cartItem = await _context.Carts.FindAsync(cartId);

                if (cartItem == null)
                {
                    return NotFound(new { Message = "Cart item not found." });
                }

                _context.Carts.Remove(cartItem);
                await _context.SaveChangesAsync();
                return Ok(new { Message = "Item saved successfully!" });
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"An error occurred: {ex.Message}");
            }
        }

        [HttpPost("AddToCart")]
        public async Task<IActionResult> AddToCart([FromBody] addcart newCartItem)
        {
            if (newCartItem == null || string.IsNullOrWhiteSpace(newCartItem.Iduser) || newCartItem.Idproduct == 0)
            {
                return BadRequest("Invalid cart item.");
            }

            try
            {
                // Check if the product already exists in the user's cart
                var existingCartItem = await _context.Carts
                    .FirstOrDefaultAsync(c => c.Iduser == newCartItem.Iduser && c.Idproduct == newCartItem.Idproduct);

                if (existingCartItem != null)
                {
                    // If the item already exists, update the quantity instead of returning an error
                    existingCartItem.Quanlity += newCartItem.Quanlity;
                    await _context.SaveChangesAsync();
                    return Ok(new { Message = "Item quantity updated in the cart!" });
                }

                // Create a new cart item and add it to the context
                var cartItem = new Cart
                {
                    Iduser = newCartItem.Iduser,
                    Idproduct = newCartItem.Idproduct,
                    Quanlity = newCartItem.Quanlity,
                    AddedDate = DateTime.UtcNow // Assuming you want to store the date when the item is added
                };

                // Add the new cart item to the context
                _context.Carts.Add(cartItem);

                await _context.SaveChangesAsync();
                return Ok(new { Message = "Item added to cart successfully!" });
            }
            catch (Exception ex)
            {
                // Log the exception if necessary
                return StatusCode(500, $"An error occurred while adding the item to the cart: {ex.Message}");
            }
        }

        // POST: api/cart
        [HttpPost]
        public async Task<ActionResult<Cart>> PostCart(Cart cart)
        {
            _context.Carts.Add(cart);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetCart", new { id = cart.Idcart }, cart);
        }

        // PUT: api/cart/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutCart(long id, Cart cart)
        {
            if (id != cart.Idcart)
            {
                return BadRequest();
            }

            _context.Entry(cart).State = EntityState.Modified;
            await _context.SaveChangesAsync();

            return NoContent();
        }
        // PUT: api/cart/update-quantity
        [HttpPut("UpdateQuantity/{cartId}")]
        public async Task<IActionResult> UpdateQuantity(long cartId, [FromBody] int newQuantity)
        {
            if (newQuantity <= 0)
            {
                return BadRequest("Số lượng phải lớn hơn 0.");
            }

            try
            {
                // Tìm sản phẩm trong giỏ hàng
                var cartItem = await _context.Carts.FindAsync(cartId);

                if (cartItem == null)
                {
                    return NotFound(new { Message = "Sản phẩm không tìm thấy trong giỏ hàng." });
                }

                // Cập nhật số lượng
                cartItem.Quanlity = newQuantity;

                // Lưu thay đổi vào cơ sở dữ liệu
                await _context.SaveChangesAsync();

                return Ok(new { Message = "Số lượng sản phẩm đã được cập nhật!" });
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Lỗi khi cập nhật số lượng: {ex.Message}");
            }
        }
        // DELETE: api/cart/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteCart(long id)
        {
            var cart = await _context.Carts.FindAsync(id);
            if (cart == null)
            {
                return NotFound();
            }

            _context.Carts.Remove(cart);
            await _context.SaveChangesAsync();

            return NoContent();
        }
    }
}
