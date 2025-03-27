using System;
using System.Collections.Generic;

namespace FlowerAppAPI.Models;

public partial class PaymentInvoice
{
    public decimal PaidPayment { get; set; }

    public DateTime? PaymentDate { get; set; }

    public long Idpayment { get; set; }

    public long Idinvoice { get; set; }

    public virtual Invoice IdinvoiceNavigation { get; set; } = null!;

    public virtual Payment IdpaymentNavigation { get; set; } = null!;
}
