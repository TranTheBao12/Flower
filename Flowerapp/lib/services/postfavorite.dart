import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient1 {
  final String apiUrl = "https://newyellowrock28.conveyor.cloud/api/Authenticate";
  final String favoriteApiUrl = "https://newyellowrock28.conveyor.cloud/api/FavoriteProduct";

  // Lấy thông tin user bằng username
  Future<String> getUserId(String userName, String token) async {
    final response = await http.get(
      Uri.parse('$apiUrl/get-user/$userName'),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print('Response data: $responseData');
      final userId = responseData['data']['id']; // Lấy id từ data
      if (userId != null) {
        return userId;
      } else {
        throw Exception('User ID not found in the response');
      }
    } else {
      print('Failed to get user ID with status code: ${response.statusCode}');
      throw Exception('Failed to load user profile');
    }
  }

  // Thêm sản phẩm yêu thích
  Future<void> addFavoriteProduct(String idUser, int idProduct, String token) async {
    final response = await http.post(
      Uri.parse(favoriteApiUrl),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "idUser": idUser,
        "idProduct": idProduct,
      }),
    );

    if (response.statusCode == 201) {
      print('Added to favorite successfully');
    } else {
      print('Failed to add favorite with status code: ${response.statusCode}');
      throw Exception('Failed to add favorite product');
    }
  }

}
