import 'package:flutter/material.dart';
import 'package:doannhom3_1/model/product.dart';
import '../services/productapi.dart';
import 'AddProductPage.dart';


class ProductListPage extends StatefulWidget {
  const ProductListPage({Key? key}) : super(key: key);

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final ApiService _apiService = ApiService();
  late Future<List<Value>> _productFuture;

  @override
  void initState() {
    super.initState();
    _productFuture = _apiService.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Management'),
      ),
      body: FutureBuilder<List<Value>>(
        future: _productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products found.'));
          } else {
            final products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: product.image != null
                        ? Image.network(
                      product.image!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image),
                    )
                        : const Icon(Icons.image),
                    title: Text(product.name ?? 'Unnamed Product'),
                    subtitle: Text('Price: ${product.price?.toStringAsFixed(2) ?? 'N/A'}VNĐ'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _showDeleteConfirmation(context, product.idproduct!);
                      },
                    ),
                    onTap: () {
                      // Điều hướng đến trang chỉnh sửa hoặc chi tiết sản phẩm
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailPage(product: product),
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
      // Thêm FloatingActionButton với biểu tượng dấu cộng
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Điều hướng đến trang AddProductPage để thêm sản phẩm
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>  AddProductPage(),
            ),
          );
        },
        child: const Icon(Icons.add), // Biểu tượng dấu cộng
        backgroundColor: Colors.green, // Màu nền của nút
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, int productId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Product'),
          content: const Text('Are you sure you want to delete this product?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteProduct(productId);
                print("Product ID to delete: $productId");
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteProduct(int productId) async {
    try {
      await _apiService.deleteProduct(productId);
      setState(() {
        _productFuture = _apiService.fetchProducts(); // Cập nhật danh sách sản phẩm sau khi xóa
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product deleted successfully.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete product: $e')),
      );
    }
  }
}
class ProductDetailPage extends StatelessWidget {
  final Value product;

  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name ?? 'Product Detail')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            product.image != null
                ? Image.network(product.image!)
                : const Icon(Icons.image, size: 100),
            const SizedBox(height: 16),
            Text('Name: ${product.name ?? 'N/A'}', style: const TextStyle(fontSize: 18)),
            Text('Description: ${product.description ?? 'N/A'}', style: const TextStyle(fontSize: 16)),
            Text('Price: ${product.price?.toStringAsFixed(2) ?? 'N/A'}VNĐ', style: const TextStyle(fontSize: 16)),
            Text('Stock: ${product.stock ?? 'N/A'}', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
