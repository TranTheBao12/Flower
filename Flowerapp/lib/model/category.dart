class CategoryResponse {
  String? id;
  List<Category>? values;

  CategoryResponse({this.id, this.values});

  // Hàm khởi tạo từ JSON
  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    return CategoryResponse(
      id: json['\$id'],
      values: (json['\$values'] as List)
          .map((item) => Category.fromJson(item))
          .toList(),
    );
  }

  // Chuyển đối tượng thành JSON
  Map<String, dynamic> toJson() {
    return {
      '\$id': id,
      '\$values': values?.map((category) => category.toJson()).toList(),
    };
  }
}

class Category {
  int? idcategory;
  String? name;
  String? description;

  Category({this.idcategory, this.name, this.description});

  // Hàm khởi tạo từ JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      idcategory: json['idcategory'],
      name: json['name'],
      description: json['description'],
    );
  }

  // Chuyển đối tượng thành JSON
  Map<String, dynamic> toJson() {
    return {
      'idcategory': idcategory,
      'name': name,
      'description': description,
    };
  }
}
