using System;
using System.Collections.Generic;

namespace FlowerAppAPI.Models;

public partial class FavoriteProduct
{
    public string IdUser { get; set; } = null!;

    public long IdProduct { get; set; }

    public long Id { get; set; }


    public virtual Product IdProductNavigation { get; set; } = null!;

    public virtual AspNetUser IdUserNavigation { get; set; } = null!;
}
