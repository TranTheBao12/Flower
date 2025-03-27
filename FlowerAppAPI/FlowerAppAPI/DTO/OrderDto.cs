namespace FlowerAppAPI.DTO
{
    public class OrderDto
    {
        public long IdStatus { get; set; }
        public decimal TotalAmount { get; set; }
        public string IdUser { get; set; }
        public long IdInvoice { get; set; }
        public long IdShip { get; set; }
    }
}
