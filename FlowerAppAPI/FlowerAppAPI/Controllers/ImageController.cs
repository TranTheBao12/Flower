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
    public class ImageController : ControllerBase
    {
        private readonly FlowerShopDbContext _context;

        public ImageController(FlowerShopDbContext context)
        {
            _context = context;
        }

        // GET: api/image
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Image>>> GetImages()
        {
            var images = await _context.Images.Include(i => i.IdproductNavigation).ToListAsync();
            return Ok(images);
        }

        // GET: api/image/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Image>> GetImage(long id)
        {
            var image = await _context.Images.Include(i => i.IdproductNavigation)
                                             .FirstOrDefaultAsync(i => i.Idimage == id);

            if (image == null)
            {
                return NotFound();
            }

            return Ok(image);
        }

        // POST: api/image
        [HttpPost]
        public async Task<ActionResult<Image>> PostImage(Image image)
        {
            _context.Images.Add(image);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetImage", new { id = image.Idimage }, image);
        }

        // PUT: api/image/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutImage(long id, Image image)
        {
            if (id != image.Idimage)
            {
                return BadRequest();
            }

            _context.Entry(image).State = EntityState.Modified;
            await _context.SaveChangesAsync();

            return NoContent();
        }

        // DELETE: api/image/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteImage(long id)
        {
            var image = await _context.Images.FindAsync(id);
            if (image == null)
            {
                return NotFound();
            }

            _context.Images.Remove(image);
            await _context.SaveChangesAsync();

            return NoContent();
        }
    }
}
