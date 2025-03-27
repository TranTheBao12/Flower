using Microsoft.AspNetCore.Identity;

namespace FlowerAppAPI.Model
{
    public class User : IdentityUser
    {
        public string? Initials { get; set; }
    }
}
