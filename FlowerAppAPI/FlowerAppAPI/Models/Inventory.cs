using System;
using System.Collections.Generic;

namespace FlowerAppAPI.Models;

public partial class Inventory
{
    public long Idinventory { get; set; }

    public long? Quanlity { get; set; }

    public DateTime? LastUpdated { get; set; }

    public long Idproduct { get; set; }

    public virtual Product IdproductNavigation { get; set; } = null!;
}
