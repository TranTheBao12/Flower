using FlowerAppAPI.DTO;
using FlowerAppAPI.Models;

namespace FlowerAppAPI.Mapper
{
    public static class CategoriesMapper
    {
        public static CategoriDOT toCategories(this Category cd)
        {
            return new CategoriDOT
            {
               Idcategory= cd.Idcategory,
               Name= cd.Name,
               Description= cd.Description,
            };
        }
    }
}
