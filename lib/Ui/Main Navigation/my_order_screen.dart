import 'package:flutter/material.dart';

import '../../Helper Funcation/custom_appBar.dart';
import 'home_screen.dart';

class MyOrderScreen extends StatefulWidget {
  const MyOrderScreen({super.key});

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      drawer: CustomNavigationDrawer(),
      appBar: CustomAppBar(title: 'My Orders'),
    );
  }
}
