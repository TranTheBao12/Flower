namespace FlowerAppAPI.DTO
{
    public class favoriteDot
    {
        public string IdUser { get; set; } = null!;

        public long IdProduct { get; set; }

        public string? ProductName { get; set; }

        public string? Description { get; set; }
        public decimal? Price { get; set; }
        public string? Image { get; set; }
    }
}
