using System;
using System.Collections.Generic;

namespace FlowerAppAPI.Models;

public partial class Cart
{
    public long Idcart { get; set; }

    public long? Quanlity { get; set; }

    public DateTime? AddedDate { get; set; }

    public string Iduser { get; set; } = null!;

    public long Idproduct { get; set; }

    public virtual Product IdproductNavigation { get; set; } = null!;

    public virtual AspNetUser IduserNavigation { get; set; } = null!;
}
