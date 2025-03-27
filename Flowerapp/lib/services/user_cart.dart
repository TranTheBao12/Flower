import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/cartproduct.dart';

class CartService {
  final String apiUrl = "https://newyellowrock28.conveyor.cloud/api/Cart";
  final String base = "https://newyellowrock28.conveyor.cloud/api/Cart";
  Future<CartResponse> fetchCartItems(String userId) async {
    try {
      // In ra URL gọi API để kiểm tra
      print('Calling API: $apiUrl/GetCartItems/$userId');

      // Thực hiện yêu cầu GET
      final response = await http.get(Uri.parse('$apiUrl/GetCartItems/$userId'));

      // In ra mã trạng thái và body của phản hồi
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Nếu yêu cầu thành công
        print('JSON Body: ${response.body}');
        final jsonBody = json.decode(response.body);
        return CartResponse.fromJson(jsonBody);
      } else if (response.statusCode == 400) {
        // Nếu API trả về mã lỗi 400, in ra lý do cụ thể
        print("Retrieved userId from SharedPreferences: $userId");
        print('Bad Request: ${response.body}');
        throw Exception('Bad Request:  print("Retrieved userId from SharedPreferences: $userId") ${response.body}');
      } else if (response.statusCode == 404) {
        // Nếu API không tìm thấy dữ liệu
        print('Cart not found for user ID: $userId');
        throw Exception('Cart not found for user ID: $userId');
      } else {
        // Trường hợp lỗi khác
        print('Failed to load cart items. Status code: ${response.statusCode}');
        throw Exception('Failed to load cart items. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Retrieved userId from SharedPreferences: $userId");
      print('API Error: $e');
      throw Exception('Failed to load cart items: $e');
    }
  }
  Future<void> deleteCartItem(int cartId) async {
    try {
      // In ra URL API để kiểm tra
      print('Calling API: $apiUrl/DeleteItem/$cartId');

      // Thực hiện yêu cầu POST để xóa sản phẩm
      final response = await http.post(Uri.parse('$apiUrl/DeleteItem/$cartId'));

      // In ra mã trạng thái và nội dung phản hồi
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Nếu yêu cầu thành công
        final responseBody = json.decode(response.body);
        print('Item deleted successfully: ${responseBody['Message']}');
      } else if (response.statusCode == 404) {
        // Nếu không tìm thấy sản phẩm
        print('Item not found: ${response.body}');
        throw Exception('Item not found.');
      } else {
        // Xử lý lỗi khác
        print('Failed to delete item. Status code: ${response.statusCode}');
        throw Exception('Failed to delete item. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // In ra lỗi nếu có ngoại lệ
      print('API Error: $e');
      throw Exception('Failed to delete item: $e');
    }
  }
  Future<void> updateCartItem(int cartId, int quantity) async {
    final url = Uri.parse('https://newyellowrock28.conveyor.cloud/api/Cart/UpdateQuantity/$cartId'); // Cập nhật URL
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(quantity), // Chỉ gửi quantity
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      print('Cart item updated: ${responseBody['Message']}');
    } else {
      final responseBody = json.decode(response.body);
      print('Failed to update cart item: ${responseBody['Message']}');
      throw Exception('Failed to update cart item: ${responseBody['Message']}');
    }
  }
}
