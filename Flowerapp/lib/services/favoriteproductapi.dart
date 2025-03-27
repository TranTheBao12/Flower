import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/favoriteproduct.dart';

Future<void> addToFavorites(FavoriteProductList product) async {
  final url = 'https://yourapi.com/favorites'; // Thay đổi URL thành API của bạn

  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      "\$id": product.id,
      "idUser ": product.idUser ,
      "idProduct": product.idProduct,
      "productName": product.productName,
      "price": product.price,
      "image": product.image,
    }),
  );

  if (response.statusCode == 200) {
    // Xử lý thành công
    print('Product added to favorites');
  } else {
    // Xử lý lỗi
    print('Failed to add product to favorites: ${response.body}');
  }
}