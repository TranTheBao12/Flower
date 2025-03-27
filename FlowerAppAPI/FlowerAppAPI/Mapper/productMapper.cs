using FlowerAppAPI.DTO;
using FlowerAppAPI.Models;

namespace FlowerAppAPI.Mapper
{
    public static class productMapper
    {
        public static productDto toProduct(this Product pd)
        {
            return new productDto
            {
                Idproduct = pd.Idproduct, 
                Name = pd.Name,
                Price = pd.Price,
                Description = pd.Description,
                Stock = pd.Stock,
                Image = pd.Image,
                CategoryName = pd.Category.Name,


            };
        }
    }
}
