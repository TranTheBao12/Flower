namespace FlowerAppAPI.DTO
{
    public class ProductPost
    {
        public long Idproduct { get; set; }

        public string? Name { get; set; }

        public string? Description { get; set; }

        public decimal? Price { get; set; }

        public long? Stock { get; set; }

        public string? Image { get; set; }

        public long CategoryId { get; set; }
    }
}
