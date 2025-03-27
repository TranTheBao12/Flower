using System;
using System.Collections.Generic;

namespace FlowerAppAPI.Models;

public partial class OrderDetail
{
    public long Idproduct { get; set; }

    public long Idorder { get; set; }

    public long? Quanlity { get; set; }

    public decimal? Price { get; set; }

    public virtual Order IdorderNavigation { get; set; } = null!;
}
