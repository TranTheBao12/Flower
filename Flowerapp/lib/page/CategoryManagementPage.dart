import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'AddCategoryPage.dart';
import 'UpdateCategoryPage.dart';

class Category {
  final int idCategory;
  final String name;
  final String description;

  Category({
    required this.idCategory,
    required this.name,
    required this.description,
  });

  // Phương thức khởi tạo từ JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      idCategory: json['idcategory'],
      name: json['name'],
      description: json['description'],
    );
  }
}

class CategoryManagementPage extends StatefulWidget {
  const CategoryManagementPage({Key? key}) : super(key: key);

  @override
  _CategoryManagementPageState createState() =>
      _CategoryManagementPageState();
}

class _CategoryManagementPageState extends State<CategoryManagementPage> {
  late Future<List<Category>> categories;

  // Lấy danh sách danh mục từ API
  Future<List<Category>> fetchCategories() async {
    final response =
    await http.get(Uri.parse('https://newyellowrock28.conveyor.cloud/api/Category'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body)['\$values'];
      return jsonData.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }
  Future<void> deleteCategory(int idCategory) async {
    final response = await http.delete(
      Uri.parse('https://newyellowrock28.conveyor.cloud/api/Category/$idCategory'),
    );

    if (response.statusCode == 204) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Danh mục đã được xóa')),
      );
      reloadCategories(); // Tải lại danh sách danh mục
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể xóa danh mục')),
      );
    }
  }
  @override
  void initState() {
    super.initState();
    categories = fetchCategories();
  }

  // Hàm reload lại danh sách danh mục
  void reloadCategories() {
    setState(() {
      categories = fetchCategories(); // Tải lại danh sách danh mục
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản Lý Danh Mục Hoa'),
        actions: [
          // Nút reload
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: reloadCategories,
          ),
        ],
      ),
      body: FutureBuilder<List<Category>>(
        future: categories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Không có danh mục nào'));
          } else {
            final categoryList = snapshot.data!;
            return ListView.builder(
              itemCount: categoryList.length,
              itemBuilder: (context, index) {
                final category = categoryList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(category.name),
                    subtitle: Text(category.description),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min, // Đảm bảo các icon không chiếm quá nhiều không gian
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // Chuyển sang màn hình chỉnh sửa danh mục
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateCategoryPage(categoryId: category.idCategory, // ID danh mục cần sửa
                                  initialName: category.name , // Tên danh mục cũ
                                  initialDescription: category.description,),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            // Chuyển sang màn hình thêm danh mục
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddCategoryPage(),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            // Hiển thị dialog xác nhận xóa
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Xóa Danh Mục'),
                                content: const Text('Bạn có chắc chắn muốn xóa danh mục này không?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Hủy'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      deleteCategory(category.idCategory);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Xóa'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

// Màn hình chỉnh sửa danh mục
class EditCategoryPage extends StatefulWidget {
  final Category category;

  const EditCategoryPage({Key? key, required this.category}) : super(key: key);

  @override
  _EditCategoryPageState createState() => _EditCategoryPageState();
}

class _EditCategoryPageState extends State<EditCategoryPage> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category.name);
    _descriptionController = TextEditingController(text: widget.category.description);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Cập nhật danh mục
  Future<void> updateCategory() async {
    final response = await http.put(
      Uri.parse('https://newyellowrock28.conveyor.cloud/api/Category/${widget.category.idCategory}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': _nameController.text,
        'description': _descriptionController.text,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pop(context, true); // Quay lại màn hình chính và thông báo thành công
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật thất bại')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh Sửa Danh Mục Hoa'),
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
              onPressed: updateCategory,
              child: const Text('Cập Nhật'),
            ),
          ],
        ),
      ),
    );
  }
}
