class Product {
  Product({
    required this.id,
    required this.values,
  });

  final String? id;
  final List<Value> values;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["\u0024id"],
      values: json["\u0024values"] == null
          ? []
          : (json["\u0024values"] is List
          ? List<Value>.from(json["\u0024values"].map((x) => Value.fromJson(x)))
          : [Value.fromJson(json["\u0024values"])]),
    );
  }

}

class Value {
  Value({
    required this.id,
    required this.idproduct,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.image,
    required this.categoryName,
  });

  final String? id;
  final int? idproduct;
  final String? name;
  final String? description;
  final int? price;
  final int? stock;
  final String? image;
  final String? categoryName;

  factory Value.fromJson(Map<String, dynamic> json){
    return Value(
      id: json["\u0024id"],
      idproduct: json["idproduct"],
      name: json["name"],
      description: json["description"],
      price: json["price"],
      stock: json["stock"],
      image: json["image"],
      categoryName: json["categoryName"],
    );
  }

}
