import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:doannhom3_1/model/User.dart'; // Import model User

class ApiClient {
  final String apiUrl = "https://newyellowrock28.conveyor.cloud/api/Authenticate"; // Thay bằng API thực tế

  Future<UserProfile> getUserProfile(String UserName, String token) async {
    final response = await http.get(
      Uri.parse('$apiUrl/get-user/$UserName'),
      headers: {
        "Authorization": "Bearer $token", // Thêm token vào header
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Response data: $data');  // Thêm print để kiểm tra dữ liệu trả về
      return UserProfile.fromJson(data);  // Giả sử bạn đã có model UserProfile
    } else {
      print('Failed with status code: ${response.statusCode}');  // Thêm để debug status code
      throw Exception('Failed to load user profile');
    }
  }
  Future<bool> updateUserProfile(String username, String token, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('https://newyellowrock28.conveyor.cloud/api/Authenticate/edit-profile/$username'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to update profile');
    }
  }
}
