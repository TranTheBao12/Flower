using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace FlowerAppAPI.Migrations
{
    /// <inheritdoc />
    public partial class category : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
      name: "FK_PRODUCT_Category",
      table: "PRODUCT");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
          
        }
    }
}
