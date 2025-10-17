import 'package:ecommerce_store/Ui/Main%20Navigation/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'Ui/Auth Screens/forgot_password.dart';
import 'Ui/Auth Screens/login_screen.dart';
import 'Ui/Auth Screens/middle_ware.dart';
import 'Ui/Auth Screens/opt_verification.dart';
import 'Ui/Auth Screens/sign_up.dart';
import 'Ui/Auth Screens/update_password.dart';
import 'Ui/Checkout/checkout_shipping_screen.dart';
import 'Ui/Main Navigation/my_order_screen.dart';
import 'Ui/Main Navigation/search_screen.dart';
import 'Ui/Notification Screens/notification_ui.dart';
import 'Ui/Walkthrough Screens/walkthrough_screen_1.dart';
import 'Ui/Walkthrough Screens/walkthrough_screen_2.dart';
import 'Ui/Main Navigation/home_screen.dart';
import 'Ui/add_to_cart_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = 'pk_test_51SJ5WIReL62G4t18gyciML5CRHoX9YtDMBHYhLmuZIu3KFWVIj3MlbfqGpv0KMo0RTmNmonWs3wojKI76vCI38a700bPI3LX1n';
  await Stripe.instance.applySettings();
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
        '/SearchScreen': (context) => const SearchScreen(),
        '/MyOrderScreen': (context) => const MyOrderScreen(),
        '/ProfileScreen': (context) => const ProfileScreen(),
        '/AddToCartScreen': (context) => const AddToCartScreen(),
        '/CheckoutShipping': (context) => const CheckoutShippingScreen(),
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
    const SearchScreen(),
    const MyOrderScreen(),
    const ProfileScreen(),
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
