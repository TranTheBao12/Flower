import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/category.dart';

class CategoryService {
  static const String _baseUrl = 'https://newyellowrock28.conveyor.cloud/api/Category';

  // Hàm GET danh mục
  Future<CategoryResponse> getCategories() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      // Kiểm tra nếu API trả về thành công (HTTP status code 200)
      if (response.statusCode == 200) {
        // Giải mã JSON và trả về đối tượng CategoryResponse
        return CategoryResponse.fromJson(jsonDecode(response.body));
      } else {
        // Nếu có lỗi trong phản hồi từ API
        throw Exception('Không thể tải danh mục, mã lỗi: ${response.statusCode}');
      }
    } catch (e) {
      // Xử lý lỗi nếu có sự cố khi kết nối mạng
      throw Exception('Đã có lỗi xảy ra: $e');
    }
  }
}
