import 'package:doannhom3_1/page/details_page.dart';
import 'package:flutter/material.dart';
import 'package:doannhom3_1/model/product.dart';
import 'package:doannhom3_1/services/productapi.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final ApiService _apiService = ApiService();
  List<Value> _searchResults = [];
  bool _isSearching = false;

  void _searchProducts() async {
    setState(() {
      _isSearching = true;
    });

    try {
      final results = await _apiService.searchProducts(_searchController.text);
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _isSearching = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search products...',
            filled: true,
            fillColor: Colors.grey[200],
            prefixIcon: Icon(Icons.search, color: Colors.green),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
          ),
          onSubmitted: (_) => _searchProducts(),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.green),
      ),
      body: _isSearching
          ? const Center(child: CircularProgressIndicator())
          : _searchResults.isEmpty
          ? const Center(child: Text('No products found'))
          : ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final product = _searchResults[index];
          return ListTile(
            leading: product.image != null
                ? Image.network(product.image!, width: 50, height: 50)
                : const Icon(Icons.image_not_supported),
            title: Text(product.name ?? 'Unknown'),
            subtitle: Text(
              '\$${product.price?.toStringAsFixed(2) ?? '0.00'}',
            ),
            onTap: () {
              // Điều hướng đến trang chi tiết sản phẩm (nếu có)
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsPage(product: product),
                ),
              );
            },
          );
        },
      ),
    );
  }
}