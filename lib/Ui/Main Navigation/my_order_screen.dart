import 'package:flutter/material.dart';
import '../../Widget/custom_appbar.dart';
import 'home_screen.dart';

class MyOrderScreen extends StatefulWidget {
  const MyOrderScreen({super.key});

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}
class _MyOrderScreenState extends State<MyOrderScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildTab(String title, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const CustomNavigationDrawer(),
      appBar: const CustomAppBar(
        showBackButton: false,
        title: 'My Orders',
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          AnimatedBuilder(
            animation: _tabController.animation!,
            builder: (context, _) {
              return TabBar(
                controller: _tabController,
                indicatorColor: Colors.transparent,
                dividerColor: Colors.transparent,
                splashFactory: NoSplash.splashFactory,
                labelPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                tabs: [
                  _buildTab("Pending", _tabController.index == 0),
                  _buildTab("Completed", _tabController.index == 1),
                  _buildTab("Cancelled", _tabController.index == 2),
                ],
                onTap: (index) {
                  setState(() {});
                },
              );
            },
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                Center(child: Text('Pending Orders')),
                Center(child: Text('Completed Orders')),
                Center(child: Text('Cancelled Orders')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
