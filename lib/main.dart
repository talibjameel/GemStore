import 'package:flutter/material.dart';
import 'Helper Funcation/cutom_button.dart';
import 'Walkthrough Screens/walkthrough_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset('res/images/Splash.png'),

          Positioned.fill(
              child:  Container(
                color: Colors.black.withValues(alpha: 0.4),
              ),
          ),

          Positioned(
            top: 520,
            left: 40,
            child: Column(
              children: [
                Text('Welcome to GemStore!',style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),),
                Text('the home for a fashionista',style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),),
                SizedBox(height: 50,),
                CustomButton(
                  text: "Get Start",
                  width: 200,
                  height: 50,
                  backgroundColor: Color(0xFF767775),
                  borderRadius: 25,
                  borderColor: Colors.white,
                  onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WalkthroughScreen()));
                  },
                ),

              ],
            ),
          )
        ],
      ),
    );
  }
}
