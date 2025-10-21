import 'package:flutter/material.dart';
import '../../Widget/cutom_button.dart';

class WalkthroughScreen1 extends StatefulWidget {
  const WalkthroughScreen1({super.key});

  @override
  State<WalkthroughScreen1> createState() => _WalkthroughScreen1State();
}
class _WalkthroughScreen1State extends State<WalkthroughScreen1> {

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
                    Navigator.pushReplacementNamed(context, '/WalkthroughScreen2');
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
