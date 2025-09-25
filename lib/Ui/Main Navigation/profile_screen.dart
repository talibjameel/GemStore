import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// 🔹 AppBar style header
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 130,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 28,
              backgroundImage: AssetImage(""),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Talib Jameel",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "talib@gmail.com",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings, color: Colors.black),
          ),
          const SizedBox(width: 10),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            /// 🔹 Options Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildProfileItem(Icons.location_on_outlined, "Address",(){}),
                  _divider(),
                  _buildProfileItem(Icons.credit_card, "Payment method",(){}),
                  _divider(),
                  _buildProfileItem(Icons.card_giftcard, "Voucher",(){}),
                  _divider(),
                  _buildProfileItem(Icons.favorite_border, "My Wishlist",(){}),
                  _divider(),
                  _buildProfileItem(Icons.star_border, "Rate this app",(){}),
                  _divider(),
                  _buildProfileItem(Icons.logout, "Log out",() async {
                    // clear flutter secure storage
                    await storage.delete(key: 'jwt_token');

                    // navigate to splash screen
                    if(context.mounted){
                      Navigator.pushReplacementNamed(context, '/MiddleWare');
                    }
                  }),
                ],
              ),
            ),
          ],
        ),
      ),

    );
  }

  /// 🔹 Profile Item Widget
  Widget _buildProfileItem(IconData icon, String title,onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey.shade600),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap:onTap,
    );
  }

  /// 🔹 Divider
  Widget _divider() {
    return Divider(height: 1, thickness: 0.5, color: Colors.grey.shade200);
  }
}
