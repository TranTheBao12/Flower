class CartResponse {
  final List<CartItem> cartItems;

  CartResponse({required this.cartItems});

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    var items = (json['\u0024values'] as List)
        .map((item) => CartItem.fromJson(item))
        .toList();
    return CartResponse(cartItems: items);
  }
}

class CartItem {
  final int idCart;
  final int quantity;
  final String addedDate;
  final Product product;

  CartItem({
    required this.idCart,
    required this.quantity,
    required this.addedDate,
    required this.product,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      idCart: json['idcart'],
      quantity: json['quanlity'],
      addedDate: json['addedDate'],
      product: Product.fromJson(json['product']),
    );
  }
}

class Product {
  final int idProduct;
  final String name;
  final String description;
  final double price;
  final String image;

  Product({
    required this.idProduct,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      idProduct: json['idproduct'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      image: json['image'],
    );
  }
}
