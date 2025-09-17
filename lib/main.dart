import 'package:flutter/material.dart';
import 'Auth/UI/forgot_password.dart';
import 'Auth/UI/login_screen.dart';
import 'Auth/UI/middle_ware.dart';
import 'Auth/UI/opt_verification.dart';
import 'Auth/UI/sign_up.dart';
import 'Auth/UI/update_password.dart';
import 'Walkthrough Screens/walkthrough_screen_1.dart';
import 'Walkthrough Screens/walkthrough_screen_2.dart';
import 'home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
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
        '/HomePage': (context) => const HomePage(),
        '/LoginScreen': (context) => const LoginScreen(),
        '/SignupScreen': (context) => const SignUpScreen(),
        '/ForgotPasswordScreen': (context) => const ForgotPasswordScreen(),
        '/UpdatePasswordScreen': (context) => const UpdatePasswordScreen(),
        '/OtpVerificationScreen': (context) => const OtpVerificationScreen(),
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
