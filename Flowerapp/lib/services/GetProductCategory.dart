import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/product.dart';

class ProductService {
  final String baseUrl = 'https://newyellowrock28.conveyor.cloud/api/Category';

  Future<List<Value>> getProductsByCategory(int categoryId) async {
    final response = await http.get(Uri.parse('$baseUrl/$categoryId/products'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      // Lấy danh sách sản phẩm từ $values
      if (data.containsKey('\$values')) {
        final List<dynamic> values = data['\$values'];
        return values.map((item) => Value.fromJson(item)).toList();
      } else {
        throw Exception('Dữ liệu trả về không chứa trường \$values');
      }
    } else {
      throw Exception('Failed to load products');
    }
  }
}
