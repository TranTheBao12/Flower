using Microsoft.AspNetCore.Mvc;
using FlowerAppAPI.Models;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using FlowerAppAPI.Mapper;
using FlowerAppAPI.DTO;

namespace FlowerAppAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CategoryController : ControllerBase
    {
        private readonly FlowerShopDbContext _context;

        public CategoryController(FlowerShopDbContext context)
        {
            _context = context;
        }
        // DELETE: api/category/{id}
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteCategory(long id)
        {
            var category = await _context.Categories
                                         .Include(c => c.Products)  // Bao gồm sản phẩm liên quan
                                         .FirstOrDefaultAsync(c => c.Idcategory == id);

            if (category == null)
            {
                return NotFound();
            }

            // Xóa các sản phẩm liên quan
            foreach (var product in category.Products.ToList())
            {
                _context.Products.Remove(product);
            }

            // Xóa danh mục
            _context.Categories.Remove(category);
            await _context.SaveChangesAsync();

            return NoContent(); // Thành công, không có nội dung trả về
        }

        // PUT: api/category/{id}
        // PUT: api/category/{id}
        [HttpPut("{id}")]
        public async Task<IActionResult> PutCategory(long id, string name, string description)
        {


            var existingCategory = await _context.Categories.FindAsync(id);

            if (existingCategory == null)
            {
                return NotFound(); // Nếu không tìm thấy danh mục, trả về NotFound
            }


            existingCategory.Name = name;
            existingCategory.Description = description;

            _context.Entry(existingCategory).State = EntityState.Modified;
            await _context.SaveChangesAsync();

            return NoContent(); // Trả về NoContent khi cập nhật thành công
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<CategoriDOT>>> GetCategories()
        {
            var categories = await _context.Categories
                .Select(c => new CategoriDOT
                {
                    Idcategory = c.Idcategory,
                    Name = c.Name,
                    Description = c.Description
                })
                .ToListAsync();

            return Ok(categories);
        }

        // POST: api/categories/addcategory
        [HttpPost("addcategory")]
        public async Task<ActionResult<CategoriDOT>> AddCategory(CategoriDOT categoryDTO)
        {
            // Chuyển đổi DTO sang model
            var category = new Category
            {
                Name = categoryDTO.Name,
                Description = categoryDTO.Description
            };

            _context.Categories.Add(category);
            await _context.SaveChangesAsync();

            categoryDTO.Idcategory = category.Idcategory;  // Set ID từ model đã thêm vào

            return CreatedAtAction(nameof(GetCategories), new { id = category.Idcategory }, categoryDTO);
        }
        // GET: api/category
        //[HttpGet]
        //public async Task<ActionResult<IEnumerable<Category>>> GetCategories()
        //{
        //    // Directly select the categories without using Include for properties
        //    var categories = await _context.Categories
        //        .ToListAsync(); // This will fetch all categories with their properties

        //    // Return the categories, applying any necessary transformation
        //    return Ok(categories.Select(p => p.toCategories()).ToList());
        //}

        // GET: api/category/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Category>> GetCategory(long id)
        {
            var category = await _context.Categories
                                                     .FirstOrDefaultAsync(c => c.Idcategory == id);

            if (category == null)
            {
                return NotFound();
            }

            return Ok(category);
        }

        // POST: api/category
        [HttpPost]
        public async Task<ActionResult<Category>> PostCategory(Category category)
        {
            _context.Categories.Add(category);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetCategory", new { id = category.Idcategory }, category);
        }

        // PUT: api/category/5
        //[HttpPut("{id}")]
        //public async Task<IActionResult> PutCategory(long id, Category category)
        //{
        //    if (id != category.Idcategory)
        //    {
        //        return BadRequest();
        //    }

        //    _context.Entry(category).State = EntityState.Modified;
        //    await _context.SaveChangesAsync();

        //    return NoContent();
        //}
        // GET: api/category/{id}/products
        [HttpGet("{id}/products")]
        public async Task<ActionResult<IEnumerable<Product>>> GetProductsByCategoryId(long id)
        {
            var category = await _context.Categories
                                         .Include(c => c.Products) // Ensure products are loaded
                                         .FirstOrDefaultAsync(c => c.Idcategory == id);

            if (category == null)
            {
                return NotFound(new { Message = "Category not found." });
            }

            var products = category.Products;

            if (products == null || !products.Any())
            {
                return NotFound(new { Message = "No products found for this category." });
            }

            return Ok(products.Select(p => p.toProduct())); // Assuming you have a DTO or mapping method
        }
        // DELETE: api/category/5
        //[HttpDelete("{id}")]
        //public async Task<IActionResult> DeleteCategory(long id)
        //{
        //    var category = await _context.Categories.FindAsync(id);
        //    if (category == null)
        //    {
        //        return NotFound();
        //    }

        //    _context.Categories.Remove(category);
        //    await _context.SaveChangesAsync();

        //    return NoContent();
        //}
    }
}
