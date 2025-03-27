import 'package:flutter/material.dart';
import '../model/product.dart';
import '../services/GetProductCategory.dart';
import 'details_page.dart'; // Đảm bảo import đúng DetailsPage

class ProductListPage extends StatelessWidget {
  final int categoryId;

  ProductListPage({required this.categoryId});

  Future<List<Value>> fetchProducts() async {
    return await ProductService().getProductsByCategory(categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách sản phẩm'),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<List<Value>>(
        future: fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Không có sản phẩm'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Không có sản phẩm'));
          } else {
            final products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: Image.network(
                      product.image ?? '',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(product.name ?? 'Không có tên'),
                    subtitle: Text('${product.price} VND'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsPage(product: product),
                        ),
                      );
                    },
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
