using FlowerAppAPI.DTO;
using FlowerAppAPI.Models;

namespace FlowerAppAPI.Mapper
{
    public static class ProductPostMapper
    {
        public static ProductPost toProductPost(this Product pd)
        {
            return new ProductPost
            {
                Idproduct = pd.Idproduct,
                Name = pd.Name,
                Price = pd.Price,
                Description = pd.Description,
                Stock = pd.Stock,
                Image = pd.Image,
                CategoryId = pd.Category.Idcategory,


            };
        }
    }
}
