import 'dart:convert';
import 'package:http/http.dart' as http;

class FavoriteService1 {
  final String apiUrl = 'https://newyellowrock28.conveyor.cloud/api/FavoriteProduct'; // Thay đổi với URL API thật của bạn

  // Lấy danh sách yêu thích
  Future<List<Map<String, dynamic>>> getFavoriteProducts(String userId) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl?userid=$userId'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // In ra dữ liệu nhận được để kiểm tra cấu trúc
        print('Data from API: $data');

        // Kiểm tra và truy cập vào trường "$values" để lấy danh sách sản phẩm yêu thích
        if (data != null && data is Map && data['\$values'] != null) {
          final List<dynamic> favoriteList = data['\$values'];
          return favoriteList
              .map((item) => {
            "idUser": item["idUser"],
            "idProduct": item["idProduct"],
            "productName": item["productName"],
            "description": item["description"],
            "price": item["price"],
            "image": item["image"]
          })
              .toList();
        } else {
          throw Exception('Invalid data format: Expected a Map with "\$values" field');
        }
      } else {
        throw Exception('Failed to load favorite products');
      }
    } catch (e) {
      throw Exception('Failed to load favorite products: $e');
    }
  }
}
