import 'package:doannhom3_1/page/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:doannhom3_1/services/accout_api_client.dart';
import 'package:doannhom3_1/model/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'EditProfilePage.dart';


class AccountPage extends StatefulWidget {
  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late ApiClient apiClient;
  UserProfile? userProfile;
  bool isLoading = true;
  String? username;
  String? token;

  @override
  void initState() {
    super.initState();
    apiClient = ApiClient();
    _loadUserData();
  }

  // Hàm lấy userId và token từ SharedPreferences
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
      token = prefs.getString('jwt_token');
    });
    print('username: $username');
    print('token: $token');
    // Sau khi lấy được userId và token, gọi API để lấy thông tin người dùng
    if (username != null && token != null) {
      _fetchUserProfile();
    }
  }

  // Hàm lấy thông tin người dùng từ API
  Future<void> _fetchUserProfile() async {
    setState(() {
      isLoading = true;
    });
    try {
      // Gọi API để lấy thông tin người dùng
      final user = await apiClient.getUserProfile(username!, token!);

      setState(() {
        userProfile = user;  // Gán đối tượng UserProfile
        isLoading = false;
      });

      // Lưu idUser vào SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('idUser', userProfile!.id);  // Lưu đúng giá trị 'id' vào SharedPreferences

      print("User ID saved to SharedPreferences: ${userProfile!.id}");
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error loading user profile: $e');
    }
  }


  // Xử lý đăng xuất
  Future<void> _handleLogout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token'); // Clear the token
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SplashPage()),
          (route) => false, // Clear the navigation stack
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userProfile == null
          ? const Center(child: Text('Failed to load profile.'))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Section
            Row(
              children: [
                Container(
                  width: 80, // Đặt chiều rộng để tương tự `CircleAvatar` (2 * radius)
                  height: 80, // Đặt chiều cao tương tự `CircleAvatar`
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade300, // Màu nền
                  ),
                  child: userProfile!.initials != null
                      ? ClipOval(
                    child: Image.asset(
                      'assets/images/thuan.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error, size: 40); // Hiển thị khi lỗi
                      },
                    ),
                  )
                      : const Icon(Icons.person, size: 40), // Hiển thị icon nếu không có ảnh
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(

                      userProfile!.userName,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userProfile!.email,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Menu Section
            const Text(
              'Menu',
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Profile'),
                    onTap: () {
                      // Navigate to profile edit page
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Settings'),
                    onTap: () {
                      // Navigate to settings
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.edit),
                    title: const Text('Edit Profile'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditProfilePage(userProfile: userProfile!)),
                      ).then((_) {
                        // Refresh profile after editing
                        _fetchUserProfile();
                      });
                    },
                  ),

                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Logout'),
                    onTap: () => _handleLogout(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Quick Actions Section
            const Text(
              'Quick Actions',
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _quickActionButton(
                  icon: Icons.add,
                  label: 'Add Post',
                  onTap: () {
                    // Handle Add Post action
                  },
                ),
                _quickActionButton(
                  icon: Icons.notifications,
                  label: 'Notifications',
                  onTap: () {
                    // Handle Notifications action
                  },
                ),
                _quickActionButton(
                  icon: Icons.message,
                  label: 'Messages',
                  onTap: () {
                    // Handle Messages action
                  },
                ),
                _quickActionButton(
                  icon: Icons.photo_album,
                  label: 'Gallery',
                  onTap: () {
                    // Handle Gallery action
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Quick Action Button
  Widget _quickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 30,
            child: Icon(icon, size: 30),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
