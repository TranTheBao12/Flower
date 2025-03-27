using System;
using System.Collections.Generic;

namespace FlowerAppAPI.Models;

public partial class Payment
{
    public long Idpayment { get; set; }

    public DateTime? PaymentDate { get; set; }

    public decimal? Amount { get; set; }

    public decimal? RefundAmount { get; set; }

    public DateTime? RefundDate { get; set; }

    public string Iduser { get; set; } = null!;

    public long Idorder { get; set; }

    public virtual AspNetUser IduserNavigation { get; set; } = null!;

    public virtual ICollection<PaymentInvoice> PaymentInvoices { get; set; } = new List<PaymentInvoice>();
}
