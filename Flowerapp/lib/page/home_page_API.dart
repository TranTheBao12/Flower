import 'dart:ui';
import 'package:doannhom3_1/widgets/menubar.dart';
import 'package:flutter/material.dart';
import 'package:doannhom3_1/core/color.dart';
import 'package:doannhom3_1/model/product.dart';
import 'package:doannhom3_1/page/details_page.dart';
import '../services/productapi.dart';
import 'AccountPage.dart';
import 'Cartpage.dart';
import 'FlowerKeyboardPage.dart';
import 'SearchProductPage.dart';
import 'TutorialPage.dart';
import 'favoritepage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Value>> futureProducts;
  PageController controller = PageController();
  int selectId = 0;
  int activePage = 0;
  int currentIndex = 0;

  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    futureProducts = apiService.fetchProducts();
    controller = PageController(viewportFraction: 0.6, initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: white,
        automaticallyImplyLeading: false,
        leadingWidth: 40,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Image.asset('assets/icons/menu.png'),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Mở Drawer khi nhấn nút menu
            },
          ),
        ),
        actions: [
          Container(
            height: 40.0,
            width: 40.0,
            margin: const EdgeInsets.only(right: 20, top: 10, bottom: 5),
            decoration: BoxDecoration(
              color: green,
              boxShadow: [
                BoxShadow(
                  color: green.withOpacity(0.5),
                  blurRadius: 10,
                  offset: const Offset(0, 0),
                ),
              ],
              borderRadius: BorderRadius.circular(10.0),
              image: const DecorationImage(
                image: AssetImage('assets/images/pro.png'),
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer( // Thêm Drawer vào Scaffold
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: green,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),ListTile(
              title: Text('Tìm Kiếm'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchPage()), // Điều hướng tới MenuBar1
                );

              },
            ),
            ListTile(
              title: Text('Danh Mục Hoa'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MenuBar1()), // Điều hướng tới MenuBar1
                );

              },
            ),

            ListTile(
              title: Text('Nhận Dạng Hoa'),
              onTap: () {
                setState(() {});
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Hoa Theo Tên'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FlowerKeyboardPage()), // Điều hướng tới MenuBar1
                );

              },
            ),
            ListTile(
              title: Text('Hoa Tết 2025'),
              onTap: () {
                setState(() {});
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Hướng Dẫn Chăm Hoa'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FlowerCareGuide()), // Điều hướng tới MenuBar1
                );

              },
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: currentIndex,
        children: [
          FutureBuilder<List<Value>>(
            future: futureProducts,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No products found'));
              } else {
                final products = snapshot.data!;
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      SizedBox(
                        height: 320.0,
                        child: PageView.builder(
                          itemCount: products.length,
                          controller: controller,
                          physics: const BouncingScrollPhysics(),
                          padEnds: false,
                          pageSnapping: true,
                          onPageChanged: (value) =>
                              setState(() => activePage = value),
                          itemBuilder: (context, index) {
                            bool active = index == activePage;
                            return slider(active, products[index]);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Popular',
                              style: TextStyle(
                                color: black.withOpacity(0.7),
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                            Image.asset(
                              'assets/icons/more.png',
                              color: green,
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 130.0,
                        child: ListView.builder(
                          itemCount: products.length,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(left: 20.0),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return productCard(products[index]);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
          FavoritePage(),
          CartPage(),
          AccountPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        selectedItemColor: green,
        unselectedItemColor: black.withOpacity(0.5),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Favorite'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Account'),
        ],
      ),
    );
  }

  AnimatedContainer slider(bool active, Value value) {
    double margin = active ? 20 : 30;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
      margin: EdgeInsets.all(margin),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsPage(product: value),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: white,
            boxShadow: [
              BoxShadow(
                color: black.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(5, 5),
              ),
            ],
            border: Border.all(color: green, width: 2),
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: lightGreen,
                  image: DecorationImage(
                    image: NetworkImage(value.image ?? ''),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: CircleAvatar(
                  backgroundColor: green,
                  radius: 15,
                  child: Image.asset(
                    'assets/icons/add.png',
                    color: white,
                    height: 15,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    '${value.name ?? ''}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFFFD700),
                      fontSize: 19.0,
                      decoration: TextDecoration.none,
                      shadows: [
                        Shadow(color: Colors.black, offset: Offset(1, 1), blurRadius: 5),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget productCard(Value value) {
    return Container(
      width: 200.0,
      margin: const EdgeInsets.only(right: 20, bottom: 10),
      decoration: BoxDecoration(
        color: lightGreen,
        boxShadow: [
          BoxShadow(
            color: green.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Image.network(
                value.image ?? '',
                width: 70,
                height: 70,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.image_not_supported),
              ),
              const SizedBox(width: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    value.name ?? '',
                    style: TextStyle(
                      color: black.withOpacity(0.7),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    '${value.price?.toStringAsFixed(0) ?? '0'}VNĐ',
                    style: TextStyle(
                      color: black.withOpacity(0.4),
                      fontWeight: FontWeight.w600,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            right: 20,
            bottom: 20,
            child: CircleAvatar(
              backgroundColor: green,
              radius: 15,
              child: Image.asset(
                'assets/icons/add.png',
                color: white,
                height: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
