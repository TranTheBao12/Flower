using System;
using System.Collections.Generic;

namespace FlowerAppAPI.Models;

public partial class Invoice
{
    public long Idinvoice { get; set; }

    public decimal? TotalAmount { get; set; }

    public DateTime? BillingDate { get; set; }

    public DateTime? CreatedAt { get; set; }

    public long Idorder { get; set; }

    public virtual Order IdorderNavigation { get; set; } = null!;

    public virtual ICollection<PaymentInvoice> PaymentInvoices { get; set; } = new List<PaymentInvoice>();
}
