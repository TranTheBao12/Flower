import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddCategoryPage extends StatefulWidget {
  const AddCategoryPage({Key? key}) : super(key: key);

  @override
  _AddCategoryPageState createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Hàm gửi yêu cầu POST để thêm danh mục
  Future<void> addCategory() async {
    final response = await http.post(
      Uri.parse('https://newyellowrock28.conveyor.cloud/api/Category/addcategory'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': _nameController.text,
        'description': _descriptionController.text,
      }),
    );

    if (response.statusCode == 200) {
      // Nếu thêm thành công, hiển thị thông báo và quay lại màn hình quản lý danh mục
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Danh mục đã được thêm thành công')),
      );
      Navigator.pop(context, true); // Quay lại trang danh mục
    } else {
      // Nếu thêm thất bại, hiển thị thông báo lỗi
      String errorMessage = 'Danh mục đã được thêm thành công';

      // Lấy chi tiết lỗi từ phản hồi JSON
      try {
        final errorData = json.decode(response.body);
        if (errorData['message'] != null) {
          errorMessage = errorData['message'];
        }
      } catch (e) {
        errorMessage = 'Lỗi kết nối mạng hoặc API không phản hồi';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm Danh Mục Hoa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Tên Danh Mục'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Mô Tả'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: addCategory,
              child: const Text('Thêm Danh Mục'),
            ),
          ],
        ),
      ),
    );
  }
}
