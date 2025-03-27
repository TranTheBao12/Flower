import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:doannhom3_1/model/product.dart';

import '../model/product2.dart';

class ApiService {
  final String baseUrl = 'https://newyellowrock28.conveyor.cloud'; // Thay bằng URL API của bạn

  Future<List<Value>> fetchProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/api/Product'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      if (jsonData["\u0024values"] != null && jsonData["\u0024values"] is List) {
        return (jsonData["\u0024values"] as List)
            .map((item) => Value.fromJson(item))
            .toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<void> deleteProduct(int productId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/Product/$productId'),
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      // Successfully deleted
      print('Product deleted successfully');
    } else {
      // Handle error
      throw Exception('Failed to delete product');
    }
  }
  Future<void> createProduct(Value1 product) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/Product'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name': product.name,
        'description': product.description,
        'price': product.price,
        'stock': product.stock,
        'image': product.image,
        'categoryId': product.categoryId,
      }),
    );

    if (response.statusCode == 201) {
      // Successfully created the product
      print('Product created successfully');
    } else {
      // Handle error
      throw Exception('Failed to create product');
    }
  }
  Future<void> updateProduct(int productId, Value1 updatedProduct) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/Product/$productId'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'idproduct': updatedProduct.id, // Nếu cần thiết
        'name': updatedProduct.name,
        'description': updatedProduct.description,
        'price': updatedProduct.price,
        'stock': updatedProduct.stock,
        'image': updatedProduct.image,
        'categoryId': updatedProduct.categoryId,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      print('Product updated successfully');
    } else {
      throw Exception('Failed to update product');
    }
  }
  Future<List<Value>> searchProducts(String query) async {
    final response = await http.get(Uri.parse('https://newyellowrock28.conveyor.cloud/api/Product/search?name=$query'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return (data['\u0024values'] as List).map((e) => Value.fromJson(e)).toList();
    } else {
      throw Exception('Failed to search products');
    }
  }
}
