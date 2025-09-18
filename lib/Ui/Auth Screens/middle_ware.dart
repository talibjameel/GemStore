import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MeddleWare extends StatefulWidget {
  const MeddleWare({super.key});

  @override
  State<MeddleWare> createState() => _MeddleWareState();
}

class _MeddleWareState extends State<MeddleWare> {
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _checkWalkthroughStatus();
  }

  Future<void> _checkWalkthroughStatus() async {
    final walkthroughSeen = await storage.read(key: 'walkthroughSeen');
    final token = await storage.read(key: 'jwt_token');

    if (!mounted) return;

    if (walkthroughSeen == null || walkthroughSeen == 'false') {
      // 🔹 Show Onboarding
      Navigator.pushReplacementNamed(context, '/WalkthroughScreen1');
    } else if (token != null && token.isNotEmpty) {
      // 🔹 User logged in
      Navigator.pushReplacementNamed(context, '/HomePage');
    } else {
      // 🔹 Show Login
      Navigator.pushReplacementNamed(context, '/LoginScreen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(color: Colors.brown),
      ),
    );
  }
}
