class FavoriteProduct {
  FavoriteProduct({
    required this.id,
    required this.values,
  });

  final String? id;
  final List<FavoriteProductList> values;

  factory FavoriteProduct.fromJson(Map<String, dynamic> json){
    return FavoriteProduct(
      id: json["\u0024id"],
      values: json["\u0024values"] == null ? [] : List<FavoriteProductList>.from(json["\u0024values"]!.map((x) => FavoriteProductList.fromJson(x))),
    );
  }

}

class FavoriteProductList {
  FavoriteProductList({
    required this.id,
    required this.idUser,
    required this.idProduct,
    required this.productName,
    required this.description,
    required this.price,
    required this.image,
  });

  final String? id;
  final String? idUser;
  final int? idProduct;
  final String? productName;
  final String? description;
  final int? price;
  final String? image;

  factory FavoriteProductList.fromJson(Map<String, dynamic> json){
    return FavoriteProductList(
      id: json["\u0024id"],
      idUser: json["idUser"],
      idProduct: json["idProduct"],
      productName: json["productName"],
      description: json["description"],
      price: json["price"],
      image: json["image"],
    );
  }

}
