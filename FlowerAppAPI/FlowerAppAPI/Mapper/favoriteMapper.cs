using FlowerAppAPI.DTO;
using FlowerAppAPI.Models;

namespace FlowerAppAPI.Mapper
{
    public static class favoriteMapper
    {
        public static favoriteDot toFavorite(this FavoriteProduct Fp)
        {
            return new favoriteDot
            {
                IdUser = Fp.IdUser,
                IdProduct = Fp.IdProduct,
                ProductName = Fp.IdProductNavigation != null ? Fp.IdProductNavigation.Name : string.Empty,
                Description = Fp.IdProductNavigation != null ? Fp.IdProductNavigation.Description : string.Empty,
                Price = Fp.IdProductNavigation != null ? Fp.IdProductNavigation.Price : 0,
                Image = Fp.IdProductNavigation != null ? Fp.IdProductNavigation.Image : string.Empty,
            };
        }
    }
}
