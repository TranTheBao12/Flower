class Value1 {
  final int? id;
  final String? name;
  final String? description;
  final double? price;
  final int? stock;
  final String? image;
  final int? categoryId;

  Value1({
    this.id,
    this.name,
    this.description,
    this.price,
    this.stock,
    this.image,
    this.categoryId,
  });

  // Khởi tạo từ JSON
  factory Value1.fromJson(Map<String, dynamic> json) {
    return Value1(
      id: json['idproduct'] as int?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      stock: json['stock'] as int?,
      image: json['image'] as String?,
      categoryId: json['categoryId'] as int?,
    );
  }

  // Chuyển đổi đối tượng Value thành JSON
  Map<String, dynamic> toJson() {
    return {
      'idproduct': id,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'image': image,
      'categoryId': categoryId,
    };
  }
}
