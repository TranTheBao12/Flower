namespace FlowerAppAPI.DTO
{
    public class InvoiceDto
    {
        public decimal TotalAmount { get; set; }
        public DateTime? BillingDate { get; set; }
        public long IdOrder { get; set; }
    }
}
