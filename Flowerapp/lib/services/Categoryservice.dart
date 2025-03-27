import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class CategoryService {
  final String baseUrl = "https://newyellowrock28.conveyor.cloud/api/Category";  // Địa chỉ API của bạn

  // Hàm để chỉnh sửa danh mục
  Future<void> updateCategory(int id, String name, String description, BuildContext context) async {
    final url = Uri.parse('$baseUrl/$id?name=$name&description=$description');

    try {
      // Gửi yêu cầu PUT
      final response = await http.put(url);

      if (response.statusCode == 204) {
        // Thành công, không có nội dung trả về
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Category updated successfully!')),
        );
      } else if (response.statusCode == 404) {
        // Không tìm thấy danh mục
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Category not found!')),
        );
      } else {
        // Các lỗi khác
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update category: ${response.statusCode}')),
        );
      }
    } catch (e) {
      // Xử lý lỗi khi gửi yêu cầu
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
