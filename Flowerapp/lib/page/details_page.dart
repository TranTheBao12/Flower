import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:doannhom3_1/core/color.dart';
import 'package:doannhom3_1/model/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/favoriteproduct.dart';
import '../services/cart_api.dart';
import '../services/favoriteproductapi.dart'; // Đảm bảo import đúng model
import '../services/getfavoriteproduct.dart';
import '../services/postfavorite.dart';

class DetailsPage extends StatefulWidget {
  final Value product; // Sử dụng Value thay vì Product
  const DetailsPage({Key? key, required this.product}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool isFavorite = false; // Trạng thái yêu thích
  final ApiClient1 apiClient = ApiClient1();
  final FavoriteService1 favoriteService = FavoriteService1();
  String? token;
  List<Map<String, dynamic>> favoriteProducts = []; // Danh sách yêu thích

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('jwt_token');
    });
  }


  Future<void> toggleFavorite() async {
    if (token == null) {
      print('Token is null');
      return;
    }

    if (widget.product.idproduct == null) {
      print('Product ID is null');
      return;
    }

    setState(() {
      isFavorite = !isFavorite;
    });

    try {
      final decodedToken = jsonDecode(
          utf8.decode(base64Url.decode(base64Url.normalize(token!.split('.')[1]))));
      final userName = decodedToken['unique_name'];
      final userId = await apiClient.getUserId(userName, token!);
      await apiClient.addFavoriteProduct(userId, widget.product.idproduct!, token!);

      // Hiển thị popup thông báo thêm vào danh sách yêu thích
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Thành công'),
            content: const Text('Sản phẩm đã được thêm vào danh sách yêu thích.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (error) {
      print('Error: $error');
      setState(() {
        isFavorite = !isFavorite;
      });

      // Hiển thị popup thông báo lỗi
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Lỗi'),
            content: Text('Không thể thêm sản phẩm vào danh sách yêu thích: $error'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: height / 2,
                  decoration: BoxDecoration(
                    color: lightGreen,
                    boxShadow: [
                      BoxShadow(
                        color: green.withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(60),
                      bottomRight: Radius.circular(60),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(widget.product.image ?? ''),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: widget.product.name ?? '',
                                  style: TextStyle(
                                    color: black.withOpacity(0.8),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                                TextSpan(
                                  text: '  (${widget.product.categoryName ?? ''})',
                                  style: TextStyle(
                                    color: black.withOpacity(0.5),
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: toggleFavorite,
                            child: Container(
                              height: 30.0,
                              width: 30.0,
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: green,
                                boxShadow: [
                                  BoxShadow(
                                    color: green.withOpacity(0.2),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Image.asset(
                                'assets/icons/heart.png',
                                color: isFavorite ? Colors.red : white,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      RichText(
                        text: TextSpan(
                          text: widget.product.description ?? '',
                          style: TextStyle(
                            color: black.withOpacity(0.8), // Tăng độ rõ ràng
                            fontSize: 16.0,               // Tăng kích thước chữ
                            height: 1.5,                  // Điều chỉnh khoảng cách dòng
                            fontWeight: FontWeight.bold,  // In đậm
                            letterSpacing: 0.5,           // Khoảng cách giữa các chữ cái
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        'Treatment',
                        style: TextStyle(
                          color: black.withOpacity(0.9),
                          fontSize: 18.0,
                          height: 1.4,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.asset('assets/icons/sun.png',
                              color: black, height: 24.0),
                          Image.asset('assets/icons/drop.png',
                              color: black, height: 24.0),
                          Image.asset('assets/icons/temperature.png',
                              color: black, height: 24.0),
                          Image.asset('assets/icons/up_arrow.png',
                              color: black, height: 24.0),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Nút quay lại
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                // Nút thêm sản phẩm vào giỏ hàng
                GestureDetector(
                  onTap: () async {
                    // Lấy userId từ SharedPreferences
                    final prefs = await SharedPreferences.getInstance();
                    String Iduser = prefs.getString('idUser') ?? '';
                    int productId = widget.product.idproduct ?? 0;

                    if (Iduser.isEmpty || productId == 0) {
                      print("Invalid userId or productId");
                      return;
                    }

                    try {
                      // Gọi API để thêm vào giỏ hàng
                      await CartApi().addToCart(1, Iduser, productId);

                      // Hiển thị thông báo thêm thành công
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Thành công'),
                            content: const Text('Sản phẩm đã được thêm vào giỏ hàng.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    } catch (error) {
                      print("Error adding product to cart: $error");

                      // Hiển thị thông báo lỗi
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Lỗi'),
                            content: Text('Không thể thêm sản phẩm vào giỏ hàng: $error'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Container(
                    height: 50.0,
                    width: 50.0,
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: green, // Set the color to green
                      boxShadow: [
                        BoxShadow(
                          color: green.withOpacity(0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Image.asset(
                      'assets/icons/cart.png', // Cart icon
                      color: white, // Set the icon color to white for visibility
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 50.0, vertical: 15.0),
                decoration: BoxDecoration(
                  color: green,
                  boxShadow: [
                    BoxShadow(
                      color: green.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, -5),
                    ),
                  ],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(60),
                  ),
                ),
                child: Text(
                  'Buy ${widget.product.price?.toStringAsFixed(0) ?? '0'}VNĐ',
                  style: TextStyle(
                    color: white.withOpacity(0.9),
                    fontSize: 18.0,
                    height: 1.4,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

