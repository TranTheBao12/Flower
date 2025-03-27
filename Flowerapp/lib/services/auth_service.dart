import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/config_url.dart';

class AuthService {
  // Đường dẫn tới API login
  String get apiUrl => "${Config_URL.baseUrl}Authenticate/login";

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        bool status = data['status'];
        if (!status) {
          return {"success": false, "message": data['message']};
        }

        // Lấy token và userId từ phản hồi
        String token = data['token'];
        String userId = data['userId'];

        // Decode token để lấy thêm thông tin
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

        // Lưu token, username, và userId vào SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', token); // Lưu token
        await prefs.setString('username', username); // Lưu username
        await prefs.setString('user_id', userId); // Lưu userId

        return {
          "success": true,
          "token": token,
          "userId": userId, // Trả về userId
          "decodedToken": decodedToken,
          "username": username, // Trả về username đã lưu
        };
      } else {
        return {"success": false, "message": "Failed to login: ${response.statusCode}"};
      }
    } catch (e) {
      return {"success": false, "message": "Network error: $e"};
    }
  }
}
