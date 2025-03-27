import 'package:flutter/material.dart';

import '../services/Categoryservice.dart';



class UpdateCategoryPage extends StatefulWidget {
  final int categoryId; // Nhận categoryId từ nơi gọi
  final String initialName;
  final String initialDescription;

  // Constructor để nhận các giá trị từ nơi gọi
  UpdateCategoryPage({
    required this.categoryId,
    required this.initialName,
    required this.initialDescription,
  });

  @override
  _UpdateCategoryPageState createState() => _UpdateCategoryPageState();
}

class _UpdateCategoryPageState extends State<UpdateCategoryPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final CategoryService _categoryService = CategoryService();

  @override
  void initState() {
    super.initState();

    // Đặt giá trị ban đầu cho controllers
    _nameController.text = widget.initialName;
    _descriptionController.text = widget.initialDescription;
  }

  void _updateCategory() {
    final name = _nameController.text;
    final description = _descriptionController.text;

    // Cập nhật danh mục với id là widget.categoryId, tên và mô tả mới
    _categoryService.updateCategory(widget.categoryId, name, description, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Category Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Category Description'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateCategory,
              child: Text('Update Category'),
            ),
          ],
        ),
      ),
    );
  }
}
