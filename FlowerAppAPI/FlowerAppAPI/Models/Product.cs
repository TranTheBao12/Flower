using System;
using System.Collections.Generic;

namespace FlowerAppAPI.Models;

public partial class Product
{
    public long Idproduct { get; set; }

    public string? Name { get; set; }

    public string? Description { get; set; }

    public decimal? Price { get; set; }

    public long? Stock { get; set; }

    public string? Image { get; set; }

    public long CategoryId { get; set; }

    public virtual ICollection<Cart> Carts { get; set; } = new List<Cart>();

    public virtual Category Category { get; set; } = null!;

    public virtual ICollection<FavoriteProduct> FavoriteProducts { get; set; } = new List<FavoriteProduct>();

    public virtual ICollection<Image> Images { get; set; } = new List<Image>();

    public virtual ICollection<Inventory> Inventories { get; set; } = new List<Inventory>();

    public virtual ICollection<AspNetUser> Users { get; set; } = new List<AspNetUser>();
}
