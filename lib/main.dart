import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'Ui/Auth Screens/forgot_password.dart';
import 'Ui/Auth Screens/login_screen.dart';
import 'Ui/Auth Screens/middle_ware.dart';
import 'Ui/Auth Screens/opt_verification.dart';
import 'Ui/Auth Screens/sign_up.dart';
import 'Ui/Auth Screens/update_password.dart';
import 'Ui/Main Navigation/profile.dart';
import 'Ui/Notification Screens/notification_ui.dart';
import 'Ui/Walkthrough Screens/walkthrough_screen_1.dart';
import 'Ui/Walkthrough Screens/walkthrough_screen_2.dart';
import 'Ui/Main Navigation/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/WalkthroughScreen1': (context) => const WalkthroughScreen1(),
        '/WalkthroughScreen2': (context) => const WalkthroughScreen2(),
        '/MiddleWare': (context) => const MeddleWare(),
        '/HomePage': (context) => const MainNavigation(),
        '/LoginScreen': (context) => const LoginScreen(),
        '/SignupScreen': (context) => const SignUpScreen(),
        '/ForgotPasswordScreen': (context) => const ForgotPasswordScreen(),
        '/UpdatePasswordScreen': (context) => const UpdatePasswordScreen(),
        '/OtpVerificationScreen': (context) => const OtpVerificationScreen(),
        '/NotificationUI': (context) => const NotificationUi(),
        '/MainNavigation': (context) => const MainNavigation(),
        '/Home': (context) =>  Home(),
      },
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MeddleWare(),
    );
  }
}

/// 🔹  Main navigationBar
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}
class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
     Home(),
    const Center(child: Text("Search Screen", style: TextStyle(fontSize: 20))),
    const Center(child: Text("Notifications Screen", style: TextStyle(fontSize: 20))),
    const Profile(),
  ];
  /// 🔹Bottom navigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[_selectedIndex],

      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Colors.grey,
              width: 0.5,
            ),
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.black54,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              currentIndex: _selectedIndex,
              elevation: 0,
              onTap: _onItemTapped,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home, size: 28), label: ''),
                BottomNavigationBarItem(icon: Icon(Icons.search, size: 28), label: ''),
                BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_checkout_sharp, size: 28), label: ''),
                BottomNavigationBarItem(icon: Icon(Icons.person, size: 28), label: ''),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
