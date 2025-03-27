using FlowerAppAPI.DTO;
using FlowerAppAPI.Mapper;
using FlowerAppAPI.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace FlowerAppAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class FavoriteProductController : ControllerBase
    {
        private readonly FlowerShopDbContext _context;

        public FavoriteProductController(FlowerShopDbContext context)
        {
            _context = context;
        }

        // GET: api/FavoriteProduct
        [HttpGet]
        public async Task<ActionResult<IEnumerable<FavoriteProduct>>> GetFavoriteProducts(string userid)
        {
            // Lấy tất cả các sản phẩm yêu thích
            var favoriteProducts = await _context.FavoriteProducts
                .Include(fp => fp.IdUserNavigation) // Bao gồm thông tin User
                .Include(fp => fp.IdProductNavigation) // Bao gồm thông tin Product
                .ToListAsync();

            // Lọc ra các sản phẩm yêu thích của người dùng có userId khớp
            var userFavoriteProducts = favoriteProducts
                .Where(fp => fp.IdUser == userid) // Lọc theo userId
                .Select(fp => fp.toFavorite()) // Chuyển đổi sang dạng mà bạn cần trả về
                .ToList();

            // Kiểm tra xem có sản phẩm yêu thích không
            if (userFavoriteProducts.Count == 0)
            {
                return NotFound("No favorite products found for this user.");
            }

            return Ok(userFavoriteProducts);
        }

        // GET: api/FavoriteProduct/{id}
        [HttpGet("{id}")]
        public async Task<ActionResult<FavoriteProduct>> GetFavoriteProduct(long id)
        {
            var favoriteProduct = await _context.FavoriteProducts
                .Include(fp => fp.IdUserNavigation)
                .Include(fp => fp.IdProductNavigation)
                .FirstOrDefaultAsync(fp => fp.Id == id);

            if (favoriteProduct == null)
            {
                return NotFound();
            }

            return favoriteProduct;
        }

        [HttpPost]
        public async Task<ActionResult<FavoriteProduct>> PostFavoriteProduct(FavoriteDTO favoriteProductDto)
        {
            // Ánh xạ DTO sang entity
            var favoriteProduct = new FavoriteProduct
            {
                IdUser = favoriteProductDto.IdUser,
                IdProduct = favoriteProductDto.IdProduct
            };

            _context.FavoriteProducts.Add(favoriteProduct);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetFavoriteProduct), new { id = favoriteProduct.Id }, favoriteProduct);
        }

        // PUT: api/FavoriteProduct/{id}
        [HttpPut("{id}")]
        public async Task<IActionResult> PutFavoriteProduct(long id, FavoriteProduct favoriteProduct)
        {
            if (id != favoriteProduct.Id)
            {
                return BadRequest();
            }

            _context.Entry(favoriteProduct).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!FavoriteProductExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // DELETE: api/FavoriteProduct/product/{idProduct}
        [HttpDelete("product/{idProduct}")]
        public async Task<IActionResult> DeleteFavoriteProductByProductId(long idProduct)
        {
            // Tìm danh sách các mục yêu thích liên quan đến idProduct
            var favoriteProducts = await _context.FavoriteProducts
                .Where(fp => fp.IdProduct == idProduct)
                .ToListAsync();

            if (favoriteProducts == null || !favoriteProducts.Any())
            {
                return NotFound(new { message = "Không tìm thấy sản phẩm yêu thích với idProduct này." });
            }

            // Xóa tất cả các mục yêu thích tìm được
            _context.FavoriteProducts.RemoveRange(favoriteProducts);
            await _context.SaveChangesAsync();

            return Ok(new { message = "Đã xóa thành công các sản phẩm yêu thích liên quan đến idProduct." });
        }

        private bool FavoriteProductExists(long id)
        {
            return _context.FavoriteProducts.Any(e => e.Id == id);
        }
    }
}
