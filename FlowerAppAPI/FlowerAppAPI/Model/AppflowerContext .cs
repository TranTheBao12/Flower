using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace FlowerAppAPI.Model
{
    public class AppflowerContext : IdentityDbContext<User>
    {
        public AppflowerContext(DbContextOptions<AppflowerContext> options)
            : base(options)
        {
        }
        protected override void OnModelCreating(ModelBuilder builder)
        {
            base.OnModelCreating(builder);
            builder.Entity<User>().Property(u => u.Initials).HasMaxLength(5);
            builder.HasDefaultSchema("identity");
        }

        // Các DbSet khác
    }
}
