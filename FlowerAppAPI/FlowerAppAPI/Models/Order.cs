using System;
using System.Collections.Generic;

namespace FlowerAppAPI.Models;

public partial class Order
{
    public long Idorder { get; set; }

    public long Idstatus { get; set; }

    public DateTime? OrderDate { get; set; }

    public decimal? TotalAmount { get; set; }

    public string Iduser { get; set; } = null!;

    public long Idinvoice { get; set; }

    public long Idship { get; set; }

    public virtual AspNetUser IduserNavigation { get; set; } = null!;

    public virtual ICollection<Invoice> Invoices { get; set; } = new List<Invoice>();

    public virtual ICollection<OrderDetail> OrderDetails { get; set; } = new List<OrderDetail>();
}
