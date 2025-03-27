using System;
using System.Collections.Generic;

namespace FlowerAppAPI.Models;

public partial class Image
{
    public long Idimage { get; set; }

    public string? ImageUrl { get; set; }

    public long Idproduct { get; set; }

    public virtual Product IdproductNavigation { get; set; } = null!;
}
