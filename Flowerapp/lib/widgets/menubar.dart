import 'package:flutter/material.dart';
import '../model/category.dart';  // Đảm bảo rằng bạn đã có model Category
import '../page/ProductPage.dart';
import '../services/getCategory.dart'; // Dịch vụ lấy danh mục từ API


class MenuBar1 extends StatelessWidget {
  final CategoryService categoryService = CategoryService();

  // Lấy dữ liệu danh mục hoa từ API
  Future<List<Category>> fetchCategories() async {
    final response = await categoryService.getCategories();
    return response.values ?? []; // Trả về danh sách category hoặc mảng rỗng nếu không có dữ liệu
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.green),  // Thay đổi từ menu thành nút back
          onPressed: () {
            Navigator.pop(context); // Quay lại trang trước (HomePage)
          },
        ),
        title: Text(
          'Danh Mục Hoa',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
      ),
      body: FutureBuilder<List<Category>>(
        future: fetchCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Không có danh mục'));
          } else {
            final categories = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return InkWell(
                  onTap: () {
                    // Điều hướng tới ProductListPage với categoryId
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductListPage(categoryId: category.idcategory ?? 0),
                      ),
                    );
                  },
                  splashColor: Colors.green.withOpacity(0.3), // Màu sóng khi nhấn
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      title: Text(
                        category.name ?? 'Không có tên',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
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
