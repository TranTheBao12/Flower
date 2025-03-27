import 'package:flutter/material.dart';
import 'package:doannhom3_1/core/color.dart';
import 'package:doannhom3_1/page/details_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/deletefavorite.dart';
import '../services/getfavoriteproduct.dart';
import 'package:doannhom3_1/model/product.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late Future<List<Map<String, dynamic>>> favoriteProducts = Future.value([]); // Khởi tạo với giá trị mặc định
  late String userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  // Lấy userId từ SharedPreferences
  void _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('user_id') ?? ''; // Lấy userId từ SharedPreferences

    if (userId.isNotEmpty) {
      _refreshFavorites();
    }
  }

  // Lấy danh sách sản phẩm yêu thích của người dùng
  void _refreshFavorites() {
    setState(() {
      favoriteProducts = FavoriteService1().getFavoriteProducts(userId); // Truyền userId vào service
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: white,
        title: Text(
          'Favorites',
          style: TextStyle(color: black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: black),
            onPressed: _refreshFavorites,
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: favoriteProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: black.withOpacity(0.7), fontSize: 16),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No favorite items yet!',
                style: TextStyle(color: black.withOpacity(0.7), fontSize: 16),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final product = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: Image.network(product['image']),
                    title: Text(
                      product['productName'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      '${product['price']}VNĐ',
                      style: TextStyle(color: black.withOpacity(0.7)),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Xóa sản phẩm'),
                            content: Text(
                                'Bạn có chắc muốn xóa sản phẩm này khỏi yêu thích?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text('Hủy'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text('Xóa'),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          try {
                            await DeleteFavoriteService().deleteFavoriteProduct(
                              product['idProduct'] as int,
                            );

                            _refreshFavorites();

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Sản phẩm đã được xóa khỏi yêu thích.')),
                            );
                          } catch (error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Không thể xóa sản phẩm: $error')),
                            );
                          }
                        }
                      },
                    ),
                    onTap: () async {
                      final result = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsPage(
                            product: Value(
                              idproduct: product['idProduct'],
                              name: product['productName'],
                              price: product['price'],
                              image: product['image'],
                              description: product['description'] ?? 'Không có mô tả',
                              categoryName: product['categoryName'] ?? '',
                              id: '',
                              stock: null,
                            ),
                          ),
                        ),
                      );

                      // Làm mới danh sách nếu sản phẩm được yêu thích
                      if (result == true) {
                        _refreshFavorites();
                      }
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
