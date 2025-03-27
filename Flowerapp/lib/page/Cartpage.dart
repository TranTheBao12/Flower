import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../core/color.dart';
import '../model/cartproduct.dart';
import '../services/user_cart.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Future<CartResponse> futureCart;
  final CartService cartService = CartService();
  double totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchCart();

  }

  Future<void> _fetchCart() async {
    final prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('user_id') ?? '';
    if (userId.isNotEmpty) {
      setState(() {
        futureCart = cartService.fetchCartItems(userId);
      });
      _calculateTotal();
    }
  }

  Future<void> _calculateTotal() async {
    final prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('user_id') ?? '';
    final cartResponse = await cartService.fetchCartItems(userId);
    double total = 0.0;
    for (var item in cartResponse.cartItems) {
      total += item.product.price * item.quantity;
    }
    setState(() {
      totalAmount = total;
    });
  }

  Future<void> _createOrderAndInvoice() async {
    final prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('user_id') ?? '';

    if (totalAmount <= 0 || userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể tạo đơn hàng.')),
      );
      return;
    }

    final url = Uri.parse('https://newyellowrock28.conveyor.cloud/api/Invoice/create-order-and-invoice');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'TotalAmount': totalAmount,
        'IdUser': userId,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      int invoiceId = responseData['invoiceId'];

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseData['message'])),
      );

      // Gọi API để lấy chi tiết hóa đơn ngay sau khi tạo đơn hàng
      final invoiceResponse = await http.get(
        Uri.parse('https://newyellowrock28.conveyor.cloud/api/Invoice/$invoiceId'),
      );

      if (invoiceResponse.statusCode == 200) {
        final invoiceData = jsonDecode(invoiceResponse.body);

        // Điều hướng sang trang chi tiết hóa đơn
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InvoiceDetailPage(invoice: invoiceData),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không thể lấy chi tiết hóa đơn!')),
        );
      }
    } else {
      final responseData = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tạo đơn hàng thất bại: ${responseData['message']}')),
      );
    }
  }





  void _deleteItem(int cartId) {
    cartService.deleteCartItem(cartId).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item deleted successfully!')),
      );
      _fetchCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: const Text('Cart'),
        backgroundColor: green,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Tải lại dữ liệu mới nhất
              _fetchCart();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Refreshing cart...')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<CartResponse>(
              future: futureCart,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.cartItems.isEmpty) {
                  return const Center(child: Text('Your cart is empty.'));
                } else {
                  final cartItems = snapshot.data!.cartItems;
                  return ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartItems[index];
                      return _cartItemCard(cartItem);
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Gía:',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${totalAmount.toStringAsFixed(2)}VNĐ',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _createOrderAndInvoice,
                  child: const Text('Mua Ngay'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  void _updateQuantity(int cartId, int newQuantity) {
    cartService.updateCartItem(cartId, newQuantity).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật số lượng thành công!')),
      );
      _fetchCart(); // Cập nhật lại danh sách giỏ hàng
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $error')),
      );
    });
  }
  Widget _cartItemCard(CartItem cartItem) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: ListTile(
        leading: Image.network(
          cartItem.product.image,
          width: 50,
          fit: BoxFit.cover,
        ),
        title: Text(cartItem.product.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gía: ${cartItem.product.price.toStringAsFixed(2)}VNĐ',
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, color: Colors.red),
                  onPressed: cartItem.quantity > 1
                      ? () {
                    _updateQuantity(cartItem.idCart, cartItem.quantity - 1);
                  }
                      : null,
                ),
                Text(
                  '${cartItem.quantity}',
                  style: const TextStyle(fontSize: 16),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.green),
                  onPressed: () {
                    _updateQuantity(cartItem.idCart, cartItem.quantity + 1);
                  },
                ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _deleteItem(cartItem.idCart),
        ),
      ),
    );
  }
}

class InvoiceDetailPage extends StatelessWidget {
  final Map<String, dynamic> invoice;

  const InvoiceDetailPage({Key? key, required this.invoice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Invoice Detail'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(16.0),
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                spreadRadius: 3,
                blurRadius: 8,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Hóa đơn số #${invoice['idinvoice']}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(height: 30, thickness: 1),
              _buildDetailRow('Số tiền thanh toán', '${invoice['totalAmount']}VNĐ'),
              const SizedBox(height: 10),
              _buildDetailRow('Ngày mua', invoice['billingDate']),
              const SizedBox(height: 10),
              _buildDetailRow('Tên người dùng', invoice['userName']),
              const SizedBox(height: 10),
              _buildDetailRow('Email', invoice['userEmail']),
              const SizedBox(height: 10),

              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Back to Cart'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
