using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using FlowerAppAPI.Models;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using FlowerAppAPI.Mapper;
using FlowerAppAPI.DTO;

namespace FlowerAppAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductController : ControllerBase
    {
        private readonly FlowerShopDbContext _context;

        public ProductController(FlowerShopDbContext context)
        {
            _context = context;
        }

        // GET: api/product
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Product>>> GetProducts()
        {
            var products = await _context.Products
                .Include(p => p.Category)  // Liên kết với Category
                .Include(p => p.Images)    // Liên kết với Images
                .Include(p => p.Inventories) // Liên kết với Inventories
               // Liên kết với OrderDetails
                .ToListAsync();

            return Ok(products.Select(s => s.toProduct()).ToList());
        }

        // GET: api/product/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Product>> GetProduct(long id)
        {
            var product = await _context.Products
                .Include(p => p.Category)  // Liên kết với Category
                .Include(p => p.Images)    // Liên kết với Images
                .Include(p => p.Inventories) // Liên kết với Inventories
              // Liên kết với OrderDetails
                .FirstOrDefaultAsync(p => p.Idproduct == id);

            if (product == null)
            {
                return NotFound();
            }

            return Ok(product);
        }
        // POST: api/product
        [HttpPost]
        public async Task<ActionResult<Product>> PostProduct(ProductPost product)
        {
            var postproduct = new Product
            {
               Idproduct=product.Idproduct,
               Name = product.Name,
               Description = product.Description,
               Price = product.Price,
               Stock = product.Stock,
               Image = product.Image,
               CategoryId = product.CategoryId,

            };
            _context.Products.Add(postproduct);
            await _context.SaveChangesAsync();
            return CreatedAtAction(nameof(GetProduct), new { id = postproduct.Idproduct }, postproduct);
        }

        // PUT: api/product/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutProduct(long id, ProductPost updatedProduct)
        {
            if (id != updatedProduct.Idproduct)
            {
                return BadRequest(new { Message = "Product ID mismatch" });
            }

            var existingProduct = await _context.Products
                .Include(p => p.Category)  // Liên kết với Category nếu cần
                .FirstOrDefaultAsync(p => p.Idproduct == id);

            if (existingProduct == null)
            {
                return NotFound(new { Message = "Product not found" });
            }

            // Cập nhật các trường cần thiết
            existingProduct.Name = updatedProduct.Name;
            existingProduct.Description = updatedProduct.Description;
            existingProduct.Price = updatedProduct.Price;
            existingProduct.Stock = updatedProduct.Stock;
            existingProduct.Image = updatedProduct.Image;
            existingProduct.CategoryId = updatedProduct.CategoryId;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                return Conflict(new { Message = "Concurrent update error" });
            }

            return Ok(new { Message = "Product updated successfully", Product = existingProduct });
        }

        [HttpGet("search")]
        public async Task<ActionResult<IEnumerable<productDto>>> SearchProductsByName(string name)
        {
            if (string.IsNullOrEmpty(name))
            {
                return BadRequest("Search term cannot be empty.");
            }

            // Tìm kiếm sản phẩm theo tên
            var products = await _context.Products
                .Include(p => p.Category)  // Liên kết với Category
                .Include(p => p.Images)    // Liên kết với Images
                .Include(p => p.Inventories) // Liên kết với Inventories
                .Where(p => p.Name.Contains(name)) // Tìm sản phẩm có tên chứa từ khóa
                .ToListAsync();

            if (!products.Any())
            {
                return NotFound("No products found.");
            }

            // Trả về kết quả tìm kiếm dưới dạng DTO
            return Ok(products.Select(p => p.toProduct()).ToList());
        }
        // DELETE: api/product/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteProduct(long id)
        {
            var product = await _context.Products.FindAsync(id);
            if (product == null)
            {
                return NotFound();
            }

            _context.Products.Remove(product);
            await _context.SaveChangesAsync();

            return NoContent();
        }

    }
}
