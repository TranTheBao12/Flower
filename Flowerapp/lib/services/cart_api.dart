import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/cartproduct.dart';

class CartApi {
  final String baseUrl = 'https://newyellowrock28.conveyor.cloud/api/Cart'; // Thay đổi URL nếu cần
  final String apiUrl = 'https://newyellowrock28.conveyor.cloud/api/Cart';
  Future<void> addToCart(int quantity, String Iduser, int productId) async {
    final url = Uri.parse('$baseUrl/AddToCart');
    final body = json.encode({
      "quanlity": quantity,  // Đảm bảo tên trường là "quanlity" thay vì "Quantity"
      "iduser": Iduser,      // Đảm bảo tên trường là "iduser" thay vì "UserId"
      "idproduct": productId, // Đảm bảo tên trường là "idproduct" thay vì "ProductId"
    });

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        print("Item added to cart successfully");
      } else {
        throw Exception("Failed to add item to cart: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }
  Future<void> updateCartItem(int cartId, int quantity) async {
    final url = Uri.parse('https://newyellowrock28.conveyor.cloud/api/Cart/update');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'cartId': cartId,
        'quantity': quantity,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update cart item');
    }
  }


}
