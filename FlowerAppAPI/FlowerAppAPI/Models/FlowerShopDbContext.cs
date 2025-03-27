using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace FlowerAppAPI.Models;

public partial class FlowerShopDbContext : DbContext
{
    public FlowerShopDbContext()
    {
    }

    public FlowerShopDbContext(DbContextOptions<FlowerShopDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<AspNetRole> AspNetRoles { get; set; }

    public virtual DbSet<AspNetRoleClaim> AspNetRoleClaims { get; set; }

    public virtual DbSet<AspNetUser> AspNetUsers { get; set; }

    public virtual DbSet<AspNetUserClaim> AspNetUserClaims { get; set; }

    public virtual DbSet<AspNetUserLogin> AspNetUserLogins { get; set; }

    public virtual DbSet<AspNetUserToken> AspNetUserTokens { get; set; }

    public virtual DbSet<Cart> Carts { get; set; }

    public virtual DbSet<Category> Categories { get; set; }

    public virtual DbSet<FavoriteProduct> FavoriteProducts { get; set; }

    public virtual DbSet<Image> Images { get; set; }

    public virtual DbSet<Inventory> Inventories { get; set; }

    public virtual DbSet<Invoice> Invoices { get; set; }

    public virtual DbSet<Order> Orders { get; set; }

    public virtual DbSet<OrderDetail> OrderDetails { get; set; }

    public virtual DbSet<Payment> Payments { get; set; }

    public virtual DbSet<PaymentInvoice> PaymentInvoices { get; set; }

    public virtual DbSet<Product> Products { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer("Server=LAPTOP-C3195G5I;Database=FlowerAppAPI;Trusted_Connection=True;MultipleActiveResultSets=true;TrustServerCertificate=True");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<AspNetRole>(entity =>
        {
            entity.ToTable("AspNetRoles", "identity");

            entity.Property(e => e.Name).HasMaxLength(256);
            entity.Property(e => e.NormalizedName).HasMaxLength(256);
        });

        modelBuilder.Entity<AspNetRoleClaim>(entity =>
        {
            entity.ToTable("AspNetRoleClaims", "identity");

            entity.Property(e => e.RoleId).HasMaxLength(450);

            entity.HasOne(d => d.Role).WithMany(p => p.AspNetRoleClaims).HasForeignKey(d => d.RoleId);
        });

        modelBuilder.Entity<AspNetUser>(entity =>
        {
            entity.ToTable("AspNetUsers", "identity");

            entity.Property(e => e.Email).HasMaxLength(256);
            entity.Property(e => e.Initials).HasMaxLength(5);
            entity.Property(e => e.NormalizedEmail).HasMaxLength(256);
            entity.Property(e => e.NormalizedUserName).HasMaxLength(256);
            entity.Property(e => e.UserName).HasMaxLength(256);

            entity.HasMany(d => d.Products).WithMany(p => p.Users)
                .UsingEntity<Dictionary<string, object>>(
                    "FavoriteProduct1",
                    r => r.HasOne<Product>().WithMany().HasForeignKey("ProductId"),
                    l => l.HasOne<AspNetUser>().WithMany().HasForeignKey("UserId"),
                    j =>
                    {
                        j.HasKey("UserId", "ProductId");
                        j.ToTable("FavoriteProducts");
                        j.HasIndex(new[] { "ProductId" }, "IX_FavoriteProducts_ProductId");
                    });

            entity.HasMany(d => d.Roles).WithMany(p => p.Users)
                .UsingEntity<Dictionary<string, object>>(
                    "AspNetUserRole",
                    r => r.HasOne<AspNetRole>().WithMany().HasForeignKey("RoleId"),
                    l => l.HasOne<AspNetUser>().WithMany().HasForeignKey("UserId"),
                    j =>
                    {
                        j.HasKey("UserId", "RoleId");
                        j.ToTable("AspNetUserRoles", "identity");
                    });
        });

        modelBuilder.Entity<AspNetUserClaim>(entity =>
        {
            entity.ToTable("AspNetUserClaims", "identity");

            entity.Property(e => e.UserId).HasMaxLength(450);

            entity.HasOne(d => d.User).WithMany(p => p.AspNetUserClaims).HasForeignKey(d => d.UserId);
        });

        modelBuilder.Entity<AspNetUserLogin>(entity =>
        {
            entity.HasKey(e => new { e.LoginProvider, e.ProviderKey });

            entity.ToTable("AspNetUserLogins", "identity");

            entity.Property(e => e.UserId).HasMaxLength(450);

            entity.HasOne(d => d.User).WithMany(p => p.AspNetUserLogins).HasForeignKey(d => d.UserId);
        });

        modelBuilder.Entity<AspNetUserToken>(entity =>
        {
            entity.HasKey(e => new { e.UserId, e.LoginProvider, e.Name });

            entity.ToTable("AspNetUserTokens", "identity");

            entity.HasOne(d => d.User).WithMany(p => p.AspNetUserTokens).HasForeignKey(d => d.UserId);
        });

        modelBuilder.Entity<Cart>(entity =>
        {
            entity.HasKey(e => e.Idcart).HasName("pk_CART");

            entity.ToTable("CART");

            entity.Property(e => e.Idcart).HasColumnName("IDCart");
            entity.Property(e => e.AddedDate).HasColumnType("datetime");
            entity.Property(e => e.Idproduct).HasColumnName("IDProduct");
            entity.Property(e => e.Iduser)
                .HasMaxLength(450)
                .HasColumnName("IDUser");

            entity.HasOne(d => d.IdproductNavigation).WithMany(p => p.Carts)
                .HasForeignKey(d => d.Idproduct)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_CART_PRODUCT");

            entity.HasOne(d => d.IduserNavigation).WithMany(p => p.Carts)
                .HasForeignKey(d => d.Iduser)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_CART_AspNetUsers");
        });

        modelBuilder.Entity<Category>(entity =>
        {
            entity.HasKey(e => e.Idcategory).HasName("pk_CATEGORIES");

            entity.ToTable("CATEGORIES");

            entity.Property(e => e.Idcategory).HasColumnName("IDCategory");
            entity.Property(e => e.Description).HasMaxLength(3000);
            entity.Property(e => e.Name).HasMaxLength(100);
        });

        modelBuilder.Entity<FavoriteProduct>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Favorite__3214EC0765E92903");

            entity.ToTable("FavoriteProduct");

            entity.Property(e => e.IdUser).HasMaxLength(450);

            entity.HasOne(d => d.IdProductNavigation).WithMany(p => p.FavoriteProducts)
                .HasForeignKey(d => d.IdProduct)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_FavoriteProduct_PRODUCT");

            entity.HasOne(d => d.IdUserNavigation).WithMany(p => p.FavoriteProducts)
                .HasForeignKey(d => d.IdUser)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_FavoriteProduct_AspNetUsers");
        });

        modelBuilder.Entity<Image>(entity =>
        {
            entity.HasKey(e => e.Idimage).HasName("pk_IMAGE");

            entity.ToTable("IMAGE");

            entity.Property(e => e.Idimage).HasColumnName("IDImage");
            entity.Property(e => e.Idproduct).HasColumnName("IDProduct");
            entity.Property(e => e.ImageUrl).HasMaxLength(100);

            entity.HasOne(d => d.IdproductNavigation).WithMany(p => p.Images)
                .HasForeignKey(d => d.Idproduct)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_IMAGE_PRODUCT");
        });

        modelBuilder.Entity<Inventory>(entity =>
        {
            entity.HasKey(e => e.Idinventory).HasName("pk_INVENTORY");

            entity.ToTable("INVENTORY");

            entity.Property(e => e.Idinventory).HasColumnName("IDInventory");
            entity.Property(e => e.Idproduct).HasColumnName("IDProduct");
            entity.Property(e => e.LastUpdated).HasColumnType("datetime");

            entity.HasOne(d => d.IdproductNavigation).WithMany(p => p.Inventories)
                .HasForeignKey(d => d.Idproduct)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_INVENTORY_PRODUCT");
        });

        modelBuilder.Entity<Invoice>(entity =>
        {
            entity.HasKey(e => e.Idinvoice).HasName("pk_INVOICE");

            entity.ToTable("INVOICE");

            entity.Property(e => e.Idinvoice).HasColumnName("IDInvoice");
            entity.Property(e => e.BillingDate).HasColumnType("datetime");
            entity.Property(e => e.CreatedAt).HasColumnType("datetime");
            entity.Property(e => e.Idorder).HasColumnName("IDOrder");
            entity.Property(e => e.TotalAmount).HasColumnType("decimal(10, 0)");

            entity.HasOne(d => d.IdorderNavigation).WithMany(p => p.Invoices)
                .HasForeignKey(d => d.Idorder)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_INVOICE_ORDER");
        });

        modelBuilder.Entity<Order>(entity =>
        {
            entity.HasKey(e => e.Idorder).HasName("pk_ORDER");

            entity.ToTable("ORDER");

            entity.Property(e => e.Idorder).HasColumnName("IDOrder");
            entity.Property(e => e.Idinvoice).HasColumnName("IDInvoice");
            entity.Property(e => e.Idship).HasColumnName("IDShip");
            entity.Property(e => e.Idstatus).HasColumnName("IDStatus");
            entity.Property(e => e.Iduser)
                .HasMaxLength(450)
                .HasColumnName("IDUser");
            entity.Property(e => e.OrderDate).HasColumnType("datetime");
            entity.Property(e => e.TotalAmount).HasColumnType("decimal(10, 0)");

            entity.HasOne(d => d.IduserNavigation).WithMany(p => p.Orders)
                .HasForeignKey(d => d.Iduser)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_ORDER_AspNetUsers");
        });

        modelBuilder.Entity<OrderDetail>(entity =>
        {
            entity.HasKey(e => new { e.Idproduct, e.Idorder }).HasName("pk_ORDER_DETAIL");

            entity.ToTable("ORDER_DETAIL");

            entity.Property(e => e.Idproduct)
                .ValueGeneratedOnAdd()
                .HasColumnName("IDProduct");
            entity.Property(e => e.Idorder).HasColumnName("IDOrder");
            entity.Property(e => e.Price).HasColumnType("decimal(10, 0)");

            entity.HasOne(d => d.IdorderNavigation).WithMany(p => p.OrderDetails)
                .HasForeignKey(d => d.Idorder)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_ORDER_DETAIL_Order");
        });

        modelBuilder.Entity<Payment>(entity =>
        {
            entity.HasKey(e => e.Idpayment).HasName("pk_PAYMENT");

            entity.ToTable("PAYMENT");

            entity.Property(e => e.Idpayment).HasColumnName("IDPayment");
            entity.Property(e => e.Amount).HasColumnType("decimal(10, 0)");
            entity.Property(e => e.Idorder).HasColumnName("IDOrder");
            entity.Property(e => e.Iduser)
                .HasMaxLength(450)
                .HasColumnName("IDUser");
            entity.Property(e => e.PaymentDate).HasColumnType("datetime");
            entity.Property(e => e.RefundAmount).HasColumnType("decimal(10, 0)");
            entity.Property(e => e.RefundDate).HasColumnType("datetime");

            entity.HasOne(d => d.IduserNavigation).WithMany(p => p.Payments)
                .HasForeignKey(d => d.Iduser)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_PAYMENT_AspNetUsers");
        });

        modelBuilder.Entity<PaymentInvoice>(entity =>
        {
            entity.HasKey(e => new { e.Idpayment, e.Idinvoice }).HasName("pk_PAYMENT_INVOICE");

            entity.ToTable("PAYMENT_INVOICE");

            entity.Property(e => e.Idpayment).HasColumnName("IDPayment");
            entity.Property(e => e.Idinvoice).HasColumnName("IDInvoice");
            entity.Property(e => e.PaidPayment)
                .ValueGeneratedOnAdd()
                .HasColumnType("decimal(10, 0)");
            entity.Property(e => e.PaymentDate).HasColumnType("datetime");

            entity.HasOne(d => d.IdinvoiceNavigation).WithMany(p => p.PaymentInvoices)
                .HasForeignKey(d => d.Idinvoice)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_PAYMENT_INVOICE_Invoice");

            entity.HasOne(d => d.IdpaymentNavigation).WithMany(p => p.PaymentInvoices)
                .HasForeignKey(d => d.Idpayment)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_PAYMENT_INVOICE_Payment");
        });

        modelBuilder.Entity<Product>(entity =>
        {
            entity.HasKey(e => e.Idproduct).HasName("pk_PRODUCT");

            entity.ToTable("PRODUCT");

            entity.Property(e => e.Idproduct).HasColumnName("IDProduct");
            entity.Property(e => e.CategoryId).HasColumnName("CategoryID");
            entity.Property(e => e.Description).HasMaxLength(3000);
            entity.Property(e => e.Image).HasMaxLength(3000);
            entity.Property(e => e.Name).HasMaxLength(50);
            entity.Property(e => e.Price).HasColumnType("decimal(10, 0)");

            entity.HasOne(d => d.Category).WithMany(p => p.Products)
                .HasForeignKey(d => d.CategoryId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_PRODUCT_Categorys");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
